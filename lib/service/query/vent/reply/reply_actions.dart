import 'package:revent/global/table_names.dart';
import 'package:revent/helper/format_date.dart';
import 'package:revent/shared/api/api_client.dart';
import 'package:revent/shared/api/api_path.dart';
import 'package:revent/shared/provider_mixins.dart';
import 'package:revent/service/query/general/base_query_service.dart';
import 'package:revent/service/query/general/comment_id_getter.dart';
import 'package:revent/service/query/general/replies_id_getter.dart';
import 'package:revent/shared/provider/vent/replies_provider.dart';

class ReplyActions extends BaseQueryService with RepliesProviderService, UserProfileProviderService {

  final String replyText;
  final String repliedBy;
  final String commentText;
  final String commentedBy;

  ReplyActions({
    required this.replyText, 
    required this.repliedBy,
    required this.commentText,
    required this.commentedBy
  });

  Future<int> _getCommentId() async {

    return await CommentIdGetter().getCommentId(
      username: commentedBy, commentText: commentText
    );

  }

  Future<Map<String, dynamic>> sendReply() async {

    final commentId = await _getCommentId();

    final response = await ApiClient.post(ApiPath.createReply, {
      'reply': replyText,
      'replied_by': repliedBy,
      'comment_id': commentId
    });

    if (response.statusCode == 201) {
      _addReply();
    }

    return {
      'status_code': response.statusCode
    };

  }

  void _addReply() {

    final now = DateTime.now();
    final formattedTimestamp = FormatDate().formatPostTimestamp(now);

    final newReply = ReplyData(
      reply: replyText,
      repliedBy: repliedBy, 
      replyTimestamp: formattedTimestamp,
      pfpData: profileProvider.profile.profilePicture
    );

    repliesProvider.addReply(newReply);

  }

  Future<void> like() async {

    final commentId = await _getCommentId();

    final replyId = await ReplyIdGetter(
      commentId: commentId
    ).getReplyId(username: repliedBy, replyText: replyText);

    const likesInfoQueryParams = 
      'WHERE reply_id = :reply_id AND liked_by = :liked_by';

    final likesInfoParams = {
      'reply_id': replyId,
      'liked_by': userProvider.user.username,
    };

    final isUserLikedReply = await _isUserLikedReply(
      likesInfoQueryParams: likesInfoQueryParams,
      likesInfoParams: likesInfoParams
    );

    await _updateReplyLikes(
      replyId: replyId,
      isUserLikedPost: isUserLikedReply
    );

    await _updateLikesInfo(
      isUserLikedPost: isUserLikedReply,
      likesInfoParams: likesInfoParams,
      likesInfoQueryParams: likesInfoQueryParams
    );

    final index = repliesProvider.replies.indexWhere(
      (reply) => reply.repliedBy == repliedBy && reply.reply == replyText
    );

    _updateCommentLikedValue(
      index: index,
      liked: isUserLikedReply,
    );

  }

  Future<void> _updateReplyLikes({
    required int replyId,
    required bool isUserLikedPost 
  }) async {

    final operationSymbol = isUserLikedPost ? '-' : '+';

    final updateLikeValueQuery = 
    '''
      UPDATE ${TableNames.commentRepliesInfo} 
      SET total_likes = total_likes $operationSymbol 1 
      WHERE reply_id = :reply_id
    ''';

    final ventInfoParams = {'reply_id': replyId};

    await executeQuery(updateLikeValueQuery, ventInfoParams);

  }

  Future<bool> _isUserLikedReply({
    required String likesInfoQueryParams,
    required Map<String, dynamic> likesInfoParams
  }) async {

    final getLikesInfoQuery = 
      'SELECT 1 FROM ${TableNames.repliesLikesInfo} $likesInfoQueryParams';

    final likesInfoResults = await executeQuery(getLikesInfoQuery, likesInfoParams);

    return likesInfoResults.rows.isNotEmpty;

  }

  Future<void> _updateLikesInfo({
    required bool isUserLikedPost,
    required Map<String, dynamic> likesInfoParams,
    required String likesInfoQueryParams,
  }) async {

    final query = isUserLikedPost 
      ? 'DELETE FROM ${TableNames.repliesLikesInfo} $likesInfoQueryParams'
      : 'INSERT INTO ${TableNames.repliesLikesInfo} (liked_by, reply_id) VALUES (:liked_by, :reply_id)';

    await executeQuery(query, likesInfoParams);

  }

  void _updateCommentLikedValue({
    required int index,
    required bool liked,
  }) {

    if (index != -1) {
      repliesProvider.likeReply(index, liked);
    }

  }

  Future<Map<String, dynamic>> delete() async {

    final commentId = await _getCommentId();

    final replyId = await ReplyIdGetter(
      commentId: commentId
    ).getReplyId(username: repliedBy, replyText: replyText);

    final response = await ApiClient.deleteById(ApiPath.deleteReply, replyId);

    if (response.statusCode == 204) {
      _removeComment();
    }

    return {
      'status_code': response.statusCode
    };

  }

  void _removeComment() {

    final index = repliesProvider.replies.indexWhere(
      (reply) => reply.repliedBy == repliedBy && reply.reply == replyText
    );

    if (index != -1) {
      repliesProvider.deleteReply(index);
    }

  }

}