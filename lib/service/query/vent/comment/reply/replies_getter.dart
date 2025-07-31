import 'package:revent/global/table_names.dart';
import 'package:revent/helper/data_converter.dart';
import 'package:revent/shared/provider_mixins.dart';
import 'package:revent/service/query/general/base_query_service.dart';
import 'package:revent/helper/extract_data.dart';
import 'package:revent/helper/format_date.dart';
import 'package:revent/service/query/general/replies_id_getter.dart';

class RepliesGetter extends BaseQueryService with UserProfileProviderService, VentProviderService {

  final int commentId;

  RepliesGetter({required this.commentId});

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
      FROM ${TableNames.commentRepliesInfo} cri 
      JOIN ${TableNames.userProfileInfo} upi
        ON cri.replied_by = upi.username 
      WHERE cri.comment_id = :comment_id 
        AND NOT EXISTS (
          SELECT 1
          FROM ${TableNames.userBlockedInfo} ubi
          WHERE ubi.blocked_by = :blocked_by 
            AND ubi.blocked_username = cri.replied_by    
        )
    ''';

    final param = {
      'comment_id': commentId,
      'blocked_by': userProvider.user.username
    };

    final results = await executeQuery(getRepliesQuery, param);

    final extractedData = ExtractData(rowsData: results);

    final reply = extractedData.extractStringColumn('reply');
    final repliedBy = extractedData.extractStringColumn('replied_by');
    final totalLikes = extractedData.extractIntColumn('total_likes');

    final replyTimestamp = FormatDate().formatToPostDate(
      data: extractedData, columnName: 'created_at'
    );

    final profilePictures = DataConverter.convertToPfp(
      extractedData.extractStringColumn('profile_picture')
    );

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

    const readLikesQuery = 
    '''
      SELECT rli.reply_id
      FROM ${TableNames.repliesLikesInfo} rli
      JOIN ${TableNames.commentRepliesInfo} cpi
        ON rli.reply_id = cpi.reply_id
      WHERE rli.liked_by = :liked_by AND cpi.comment_id = :comment_id
    ''';

    final params = {
      'liked_by': isLikedByCreator ? activeVentProvider.ventData.creator : userProvider.user.username,
      'comment_id': commentId
    };

    final results = await executeQuery(readLikesQuery, params);

    final extractedIds = ExtractData(rowsData: results).extractIntColumn('reply_id');

    return List<bool>.generate(
      repliesIds.length,
      (i) => extractedIds.contains(repliesIds[i]),
    );

  }

}