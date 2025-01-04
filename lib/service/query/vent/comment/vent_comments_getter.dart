import 'dart:convert';

import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/main.dart';
import 'package:revent/service/query/general/base_query_service.dart';
import 'package:revent/helper/extract_data.dart';
import 'package:revent/helper/format_date.dart';
import 'package:revent/service/query/general/post_id_getter.dart';

class VentCommentsGetter extends BaseQueryService {

  final String title;
  final String creator;

  VentCommentsGetter({
    required this.title,
    required this.creator
  });

  final formatTimestamp = FormatDate();

  final userData = getIt.userProvider;

  Future<Map<String, List<dynamic>>> getComments() async {

    final postId = await PostIdGetter(title: title, creator: creator).getPostId();

    const getCommentsQuery = 
    '''
      SELECT vent_comments_info.comment, 
        vent_comments_info.commented_by,
        vent_comments_info.created_at,
        vent_comments_info.total_likes, 
        user_profile_info.profile_picture 
      FROM vent_comments_info 
      JOIN user_profile_info 
      ON vent_comments_info.commented_by = user_profile_info.username 
      WHERE vent_comments_info.post_id = :post_id
    ''';

    final param = {'post_id': postId};

    final results = await executeQuery(getCommentsQuery, param);

    final extractedData = ExtractData(rowsData: results);

    final comment = extractedData.extractStringColumn('comment');
    final commentedBy = extractedData.extractStringColumn('commented_by');
    final totalLikes = extractedData.extractIntColumn('total_likes');

    final commentTimestamp = extractedData
      .extractStringColumn('created_at')
      .map((timestamp) => formatTimestamp.formatPostTimestamp(DateTime.parse(timestamp)))
      .toList();

    final profilePictures = extractedData.extractStringColumn('profile_picture')
      .map((pfp) => base64Decode(pfp))
      .toList();

    final isLikedState = await _commentLikedState(
      postId: postId,
      commentedBy: commentedBy, 
      comments: comment
    );

    final isLikedByCreatorState = await _commentLikedByCreatorState(
      postId: postId,
      commentedBy: commentedBy, 
      comments: comment
    );

    return {
      'commented_by': commentedBy,
      'comment': comment,
      'comment_timestamp': commentTimestamp,
      'total_likes': totalLikes,
      'is_liked': isLikedState,
      'is_liked_by_creator': isLikedByCreatorState,
      'profile_picture': profilePictures,
    };

  }

  Future<List<bool>> _commentLikedState({
    required int postId,
    required List<String> commentedBy,
    required List<String> comments
  }) async {

    const readLikesQuery = 
    '''
      SELECT 
          vcli.commented_by, 
          vcli.comment
      FROM vent_comments_likes_info vcli
      JOIN vent_comments_info vci
          ON vcli.comment = vci.comment
          AND vcli.commented_by = vci.commented_by
      WHERE vcli.liked_by = :liked_by AND vci.post_id = :post_id;
    ''';

    final params = {
      'liked_by': userData.user.username,
      'post_id': postId
    };

    final results = await executeQuery(readLikesQuery, params);

    final likedPairs = results.rows.map((row) {
      return '${row.assoc()['commented_by']}|${row.assoc()['comment']}';
    }).toSet();

    return List<bool>.generate(
      commentedBy.length,
      (i) => likedPairs.contains('${commentedBy[i]}|${comments[i]}'),
    );
    
  }

  Future<List<bool>> _commentLikedByCreatorState({
    required int postId,
    required List<String> commentedBy,
    required List<String> comments
  }) async {

    const readLikesQuery = 
    '''
      SELECT 
        vcli.commented_by, 
        vcli.comment
      FROM vent_comments_likes_info vcli
      JOIN vent_comments_info vci
        ON vcli.comment = vci.comment
        AND vcli.commented_by = vci.commented_by
      WHERE vcli.liked_by = :liked_by AND vci.post_id = :post_id;
    ''';
      
    final params = {
      'liked_by': creator,
      'post_id': postId
    };

    final results = await executeQuery(readLikesQuery, params);

    final likedPairs = results.rows.map((row) {
      return '${row.assoc()['commented_by']}|${row.assoc()['comment']}';
    }).toSet();

    return List<bool>.generate(
      commentedBy.length,
      (i) => likedPairs.contains('${commentedBy[i]}|${comments[i]}'),
    );
    
  }

}