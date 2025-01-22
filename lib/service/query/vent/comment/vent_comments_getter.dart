import 'dart:convert';

import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/main.dart';
import 'package:revent/service/query/general/base_query_service.dart';
import 'package:revent/helper/extract_data.dart';
import 'package:revent/helper/format_date.dart';
import 'package:revent/service/query/general/comment_id_getter.dart';
import 'package:revent/service/query/general/post_id_getter.dart';

class VentCommentsGetter extends BaseQueryService {

  final formatTimestamp = FormatDate();

  final userData = getIt.userProvider.user;
  final activeVent = getIt.activeVentProvider.ventData;

  Future<Map<String, List<dynamic>>> getComments() async {

    final postId = await PostIdGetter(title: activeVent.title, creator: activeVent.creator).getPostId();

    final commentIds = await CommentIdGetter(postId: postId).getAllCommentsId();

    const getCommentsQuery = 
    '''
      SELECT 
        vci.comment, 
        vci.commented_by,
        vci.created_at,
        vci.total_likes,
        vci.total_replies, 
        upi.profile_picture
      FROM vent_comments_info vci
      JOIN user_profile_info upi 
        ON vci.commented_by = upi.username 
      LEFT JOIN user_blocked_info ubi
        ON vci.commented_by = ubi.blocked_username 
        AND ubi.blocked_by = :blocked_by
      WHERE vci.post_id = :post_id
        AND ubi.blocked_username IS NULL
    ''';

    final param = {
      'post_id': postId,
      'blocked_by': userData.username
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
      SELECT vcli.comment_id
      FROM vent_comments_likes_info vcli
      JOIN vent_comments_info vci
        ON vcli.comment_id = vci.comment_id
      WHERE vcli.liked_by = :liked_by AND vci.post_id = :post_id;
    ''';

    final params = {
      'liked_by': isLikedByCreator ? activeVent.creator : userData.username,
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