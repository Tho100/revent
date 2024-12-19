import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:revent/service/revent_connection_service.dart';
import 'package:revent/model/extract_data.dart';
import 'package:revent/model/format_date.dart';
import 'package:revent/provider/user_data_provider.dart';

class VentCommentsGetter {

  final String title;
  final String creator;

  VentCommentsGetter({
    required this.title,
    required this.creator
  });

  final formatTimestamp = FormatDate();

  final userData = GetIt.instance<UserDataProvider>();

  Future<Map<String, List<dynamic>>> getComments() async {

    final conn = await ReventConnection.connect();

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
      WHERE vent_comments_info.title = :title 
        AND vent_comments_info.creator = :creator
    ''';

    final params = {
      'title': title,
      'creator': creator,
    };

    final results = await conn.execute(getCommentsQuery, params);

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
      conn: conn, commentedBy: commentedBy, comments: comment
    );

    final isLikedByCreatorState = await _commentLikedByCreatorState(
      conn: conn, commentedBy: commentedBy, comments: comment
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
    required MySQLConnectionPool conn,
    required List<String> commentedBy,
    required List<String> comments,
  }) async {

    const readLikesQuery =
      'SELECT commented_by, comment FROM vent_comments_likes_info WHERE liked_by = :liked_by AND creator = :creator AND title = :title';

    final params = {
      'liked_by': userData.user.username,
      'creator': creator,
      'title': title,
    };

    final results = await conn.execute(readLikesQuery, params);

    final likedPairs = results.rows.map((row) {
      return '${row.assoc()['commented_by']}|${row.assoc()['comment']}';
    }).toSet();

    return List<bool>.generate(
      commentedBy.length,
      (i) => likedPairs.contains('${commentedBy[i]}|${comments[i]}'),
    );
    
  }

  Future<List<bool>> _commentLikedByCreatorState({
    required MySQLConnectionPool conn,
    required List<String> commentedBy,
    required List<String> comments,
  }) async {

    const readLikesQuery =
      'SELECT commented_by, comment FROM vent_comments_likes_info WHERE liked_by = :liked_by AND creator = :creator AND title = :title';

    final params = {
      'liked_by': creator,
      'creator': creator,
      'title': title,
    };

    final results = await conn.execute(readLikesQuery, params);

    final likedPairs = results.rows.map((row) {
      return '${row.assoc()['commented_by']}|${row.assoc()['comment']}';
    }).toSet();

    return List<bool>.generate(
      commentedBy.length,
      (i) => likedPairs.contains('${commentedBy[i]}|${comments[i]}'),
    );
    
  }

}