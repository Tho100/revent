import 'package:revent/global/table_names.dart';
import 'package:revent/helper/format_date.dart';
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

  Future<void> sendReply() async {

    await _createReplyTransaction().then(
      (_) => _addReply()
    );

  }

  Future<void> _createReplyTransaction() async {

    final commentId = await _getCommentId();

    final conn = await connection();

    await conn.transactional((txn) async {
      
      await txn.execute(
        '''
          INSERT INTO ${TableNames.commentRepliesInfo}
            (reply, comment_id, replied_by) 
          VALUES 
          (:reply, :comment_id, :replied_by)
        ''',
        {
          'reply': replyText,
          'comment_id': commentId,
          'replied_by': repliedBy,
        },
      );

      await txn.execute(
        'UPDATE ${TableNames.commentsInfo} SET total_replies = total_replies + 1 WHERE comment_id = :comment_id',
        {'comment_id': commentId}
      );

    });

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

    const likesInfoParameterQuery = 
      'WHERE reply_id = :reply_id AND liked_by = :liked_by';

    final likesInfoParams = {
      'reply_id': replyId,
      'liked_by': userProvider.user.username,
    };

    final isUserLikedReply = await _isUserLikedReply(
      likesInfoParams: likesInfoParams,
      likesInfoParameterQuery: likesInfoParameterQuery
    );

    await _updateReplyLikes(
      replyId: replyId,
      isUserLikedPost: isUserLikedReply
    );

    await _updateLikesInfo(
      isUserLikedPost: isUserLikedReply,
      likesInfoParams: likesInfoParams,
      likesInfoParameterQuery: likesInfoParameterQuery
    );

    final index = repliesProvider.replies.indexWhere(
      (reply) => reply.repliedBy == repliedBy && reply.reply == replyText
    );

    _updateCommentLikedValue(
      index: index,
      isUserLikedComment: isUserLikedReply,
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
    required Map<String, dynamic> likesInfoParams,
    required String likesInfoParameterQuery  
  }) async {

    final readLikesInfoQuery = 
      'SELECT 1 FROM ${TableNames.repliesLikesInfo} $likesInfoParameterQuery';

    final likesInfoResults = await executeQuery(readLikesInfoQuery, likesInfoParams);

    return likesInfoResults.rows.isNotEmpty;

  }

  Future<void> _updateLikesInfo({
    required bool isUserLikedPost,
    required Map<String, dynamic> likesInfoParams,
    required String likesInfoParameterQuery,
  }) async {

    final query = isUserLikedPost 
      ? 'DELETE FROM ${TableNames.repliesLikesInfo} $likesInfoParameterQuery'
      : 'INSERT INTO ${TableNames.repliesLikesInfo} (liked_by, reply_id) VALUES (:liked_by, :reply_id)';

    await executeQuery(query, likesInfoParams);

  }

  void _updateCommentLikedValue({
    required int index,
    required bool isUserLikedComment,
  }) {

    if (index != -1) {
      repliesProvider.likeReply(index, isUserLikedComment);
    }

  }

  Future<void> delete() async {

    final commentId = await _getCommentId();

    final replyId = await ReplyIdGetter(
      commentId: commentId
    ).getReplyId(username: repliedBy, replyText: replyText);

    final conn = await connection();

    await conn.transactional((txn) async {

      await txn.execute(
        'DELETE FROM ${TableNames.commentRepliesInfo} WHERE reply_id = :reply_id',
        {'reply_id': replyId}
      );

      await txn.execute(
        'UPDATE ${TableNames.commentsInfo} SET total_replies = total_replies - 1 WHERE comment_id = :comment_id',
        {'comment_id': commentId}
      );

    }).then(
      (_) => _removeComment()
    );

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