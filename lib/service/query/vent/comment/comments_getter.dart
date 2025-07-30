import 'package:revent/global/table_names.dart';
import 'package:revent/helper/data_converter.dart';
import 'package:revent/shared/provider_mixins.dart';
import 'package:revent/service/query/general/base_query_service.dart';
import 'package:revent/helper/extract_data.dart';
import 'package:revent/helper/format_date.dart';
import 'package:revent/service/query/general/comment_id_getter.dart';

class CommentsGetter extends BaseQueryService with UserProfileProviderService, VentProviderService {

  Future<Map<String, List<dynamic>>> getComments() async {

    final commentIds = await CommentIdGetter().getAllCommentsId();
  // TODO: Improve this query
    const getCommentsQuery = 
    '''
      SELECT 
        ci.comment_id,
        ci.comment, 
        ci.commented_by,
        ci.created_at,
        ci.total_likes,
        ci.total_replies, 
        ci.is_edited,
        upi.profile_picture
      ${TableNames.commentsInfo} ci
      JOIN user_profile_info upi 
        ON ci.commented_by = upi.username 
      LEFT JOIN user_blocked_info ubi
        ON ci.commented_by = ubi.blocked_username 
        AND ubi.blocked_by = :blocked_by
      WHERE ci.post_id = :post_id
        AND ubi.blocked_username IS NULL
      ORDER BY created_at ASC
    ''';

    final param = {
      'post_id': activeVentProvider.ventData.postId,
      'blocked_by': userProvider.user.username
    };

    final results = await executeQuery(getCommentsQuery, param);

    final extractedData = ExtractData(rowsData: results);

    final comment = extractedData.extractStringColumn('comment');
    final commentedBy = extractedData.extractStringColumn('commented_by');

    final totalLikes = extractedData.extractIntColumn('total_likes');
    final totalReplies = extractedData.extractIntColumn('total_replies');

    final commentTimestamp = FormatDate().formatToPostDate(
      data: extractedData, columnName: 'created_at'
    );

    final profilePictures = DataConverter.convertToPfp(
      extractedData.extractStringColumn('profile_picture')
    );

    final isLikedState = await _commentLikedState(
      isLikedByCreator: false,
      commentIds: commentIds,
    );

    final isLikedByCreatorState = await _commentLikedState(
      isLikedByCreator: true,
      commentIds: commentIds,
    );

    final isEdited = extractedData
      .extractIntColumn('is_edited')
      .map((value) => value != 0)
      .toList();

    final isPinned = await _commentPinnedState(commentIds: commentIds);

    return {
      'commented_by': commentedBy,
      'comment': comment,
      'comment_timestamp': commentTimestamp,
      'total_likes': totalLikes,
      'total_replies': totalReplies,
      'is_liked': isLikedState,
      'is_liked_by_creator': isLikedByCreatorState,
      'is_pinned': isPinned,
      'is_edited': isEdited,
      'profile_picture': profilePictures,
    };

  }

  Future<List<bool>> _commentPinnedState({required List<int> commentIds}) async {

    const query = 'SELECT comment_id ${TableNames.pinnedCommentsInfo} WHERE pinned_by = :username';

    final param = {'username': activeVentProvider.ventData.creator};

    final retrievedIds = await executeQuery(query, param);

    final extractIds = ExtractData(rowsData: retrievedIds).extractIntColumn('comment_id');

    final statePostIds = extractIds.toSet();

    return commentIds.map((commentId) => statePostIds.contains(commentId)).toList();

  }

  Future<List<bool>> _commentLikedState({
    required bool isLikedByCreator,
    required List<int> commentIds,
  }) async {

    const readLikesQuery = 
    '''
      SELECT cli.comment_id
      ${TableNames.commentsLikesInfo} cli
      JOIN comments_info ci
        ON cli.comment_id = ci.comment_id
      WHERE cli.liked_by = :liked_by AND ci.post_id = :post_id;
    ''';

    final params = {
      'liked_by': isLikedByCreator ? activeVentProvider.ventData.creator : userProvider.user.username,
      'post_id': activeVentProvider.ventData.postId
    };

    final results = await executeQuery(readLikesQuery, params);

    final extractedIds = ExtractData(rowsData: results).extractIntColumn('comment_id');

    return List<bool>.generate(
      commentIds.length,
      (i) => extractedIds.contains(commentIds[i]),
    );
    
  }

}