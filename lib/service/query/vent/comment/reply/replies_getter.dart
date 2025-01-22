import 'dart:convert';

import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/main.dart';
import 'package:revent/service/query/general/base_query_service.dart';
import 'package:revent/helper/extract_data.dart';
import 'package:revent/helper/format_date.dart';
import 'package:revent/service/query/general/replies_id_getter.dart';

class RepliesGetter extends BaseQueryService {

  final int commentId;

  RepliesGetter({required this.commentId});

  final formatTimestamp = FormatDate();

  final userData = getIt.userProvider.user;

  Future<Map<String, List<dynamic>>> getReplies() async {

    final repliesIds = await ReplyIdGetter(commentId: commentId).getAllRepliesId();

    const getRepliesQuery = 
    '''
      SELECT 
        cri.reply, 
        cri.replied_by,
        cri.created_at,
        cri.total_likes, 
        upi.profile_picture 
      FROM comment_replies_info cri 
      JOIN user_profile_info upi
        ON cri.replied_by = upi.username 
      LEFT JOIN user_blocked_info ubi
        ON cri.replied_by = ubi.blocked_username AND ubi.blocked_by = :blocked_by
      WHERE cri.comment_id = :comment_id AND ubi.blocked_username IS NULL
    ''';

    final param = {
      'comment_id': commentId,
      'blocked_by': userData.username
    };

    final results = await executeQuery(getRepliesQuery, param);

    final extractedData = ExtractData(rowsData: results);

    final reply = extractedData.extractStringColumn('reply');
    final repliedBy = extractedData.extractStringColumn('replied_by');
    final totalLikes = extractedData.extractIntColumn('total_likes');

    final replyTimestamp = extractedData
      .extractStringColumn('created_at')
      .map((timestamp) => formatTimestamp.formatPostTimestamp(DateTime.parse(timestamp)))
      .toList();

    final profilePictures = extractedData.extractStringColumn('profile_picture')
      .map((pfp) => base64Decode(pfp))
      .toList();

    final isLikedState = await _replyLikedState(
      commentId: commentId,
      isLikedByCreator: false,
      repliesIds: repliesIds,
    );

    final isLikedByCreatorState = await _replyLikedState(
      commentId: commentId,
      isLikedByCreator: true,
      repliesIds: repliesIds,
    );

    return {
      'replied_by': repliedBy,
      'reply': reply,
      'reply_timestamp': replyTimestamp,
      'total_likes': totalLikes,
      'is_liked': isLikedState,
      'is_liked_by_creator': isLikedByCreatorState,
      'profile_picture': profilePictures,
    };

  }

  Future<List<bool>> _replyLikedState({
    required int commentId,
    required bool isLikedByCreator,
    required List<int> repliesIds,
  }) async {

    return List<bool>.generate(repliesIds.length, (index) => false);

    /*const readLikesQuery = 
    '''
      SELECT vcli.comment_id
      FROM vent_comments_likes_info vcli
      JOIN vent_comments_info vci
        ON vcli.comment_id = vci.comment_id
      WHERE vcli.liked_by = :liked_by AND vci.post_id = :post_id;
    ''';

    final params = {
      'liked_by': isLikedByCreator ? creator : userData.user.username,
      'comment_id': commentId
    };

    final results = await executeQuery(readLikesQuery, params);

    final extractedIds = ExtractData(rowsData: results).extractIntColumn('comment_id');

    return List<bool>.generate(
      repliesIds.length,
      (i) => extractedIds.contains(repliesIds[i]),
    );*/
    
  }

}