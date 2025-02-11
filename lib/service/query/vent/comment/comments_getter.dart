import 'dart:convert';

import 'package:revent/helper/providers_service.dart';
import 'package:revent/service/query/general/base_query_service.dart';
import 'package:revent/helper/extract_data.dart';
import 'package:revent/helper/format_date.dart';
import 'package:revent/service/query/general/comment_id_getter.dart';
import 'package:revent/service/query/general/post_id_getter.dart';

class CommentsGetter extends BaseQueryService with UserProfileProviderService, VentProviderService {

  final formatTimestamp = FormatDate();

  Future<Map<String, List<dynamic>>> getComments() async {

    final postId = await PostIdGetter(
      title: activeVentProvider.ventData.title, creator: activeVentProvider.ventData.creator
    ).getPostId();

    final commentIds = await CommentIdGetter(postId: postId).getAllCommentsId();

    const getCommentsQuery = 
    '''
      SELECT 
        ci.comment, 
        ci.commented_by,
        ci.created_at,
        ci.total_likes,
        ci.total_replies, 
        upi.profile_picture
      FROM comments_info ci
      JOIN user_profile_info upi 
        ON ci.commented_by = upi.username 
      LEFT JOIN user_blocked_info ubi
        ON ci.commented_by = ubi.blocked_username 
        AND ubi.blocked_by = :blocked_by
      WHERE ci.post_id = :post_id
        AND ubi.blocked_username IS NULL
    ''';

    final param = {
      'post_id': postId,
      'blocked_by': userProvider.user.username
    };

    final results = await executeQuery(getCommentsQuery, param);

    final extractedData = ExtractData(rowsData: results);

    final comment = extractedData.extractStringColumn('comment');
    final commentedBy = extractedData.extractStringColumn('commented_by');

    final totalLikes = extractedData.extractIntColumn('total_likes');
    final totalReplies = extractedData.extractIntColumn('total_replies');

    final commentTimestamp = extractedData
      .extractStringColumn('created_at')
      .map((timestamp) => formatTimestamp.formatPostTimestamp(DateTime.parse(timestamp)))
      .toList();

    final profilePictures = extractedData.extractStringColumn('profile_picture')
      .map((pfp) => base64Decode(pfp))
      .toList();

    final isLikedState = await _commentLikedState(
      postId: postId,
      isLikedByCreator: false,
      commentIds: commentIds,
    );

    final isLikedByCreatorState = await _commentLikedState(
      postId: postId,
      isLikedByCreator: true,
      commentIds: commentIds,
    );

    return {
      'commented_by': commentedBy,
      'comment': comment,
      'comment_timestamp': commentTimestamp,
      'total_likes': totalLikes,
      'total_replies': totalReplies,
      'is_liked': isLikedState,
      'is_liked_by_creator': isLikedByCreatorState,
      'profile_picture': profilePictures,
    };

  }

  Future<List<bool>> _commentLikedState({
    required int postId,
    required bool isLikedByCreator,
    required List<int> commentIds,
  }) async {

    const readLikesQuery = 
    '''
      SELECT cli.comment_id
      FROM comments_likes_info cli
      JOIN comments_info ci
        ON cli.comment_id = ci.comment_id
      WHERE cli.liked_by = :liked_by AND ci.post_id = :post_id;
    ''';

    final params = {
      'liked_by': isLikedByCreator ? activeVentProvider.ventData.creator : userProvider.user.username,
      'post_id': postId
    };

    final results = await executeQuery(readLikesQuery, params);

    final extractedIds = ExtractData(rowsData: results).extractIntColumn('comment_id');

    return List<bool>.generate(
      commentIds.length,
      (i) => extractedIds.contains(commentIds[i]),
    );
    
  }

}