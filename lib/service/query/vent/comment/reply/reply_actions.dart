import 'package:revent/helper/format_date.dart';
import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/main.dart';
import 'package:revent/service/query/general/base_query_service.dart';
import 'package:revent/service/query/general/comment_id_getter.dart';
import 'package:revent/service/query/general/post_id_getter.dart';
import 'package:revent/service/query/general/replies_id_getter.dart';
import 'package:revent/shared/provider/vent/comment_replies_provider.dart';

class ReplyActions extends BaseQueryService {

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

  final activeVent = getIt.activeVentProvider.ventData;
  final repliesProvider = getIt.commentRepliesProvider;

  Future<int> _getCommentId() async {

    final postId = await PostIdGetter(title: activeVent.title, creator: activeVent.creator).getPostId();

    return await CommentIdGetter(postId: postId).getCommentId(
      username: commentedBy, commentText: commentText
    );

  }

  Future<void> sendReply() async {
   
    final commentId = await _getCommentId();

    const query = 
      'INSERT INTO comment_replies_info (reply, comment_id, replied_by, total_likes) VALUES (:reply, :comment_id, :replied_by, :total_likes)';

    final params = {
      'reply': replyText,
      'comment_id': commentId,
      'replied_by': repliedBy,
      'total_likes': 0
    };

    await executeQuery(query, params).then(
      (_) async => await _updateRepliesInfo(commentId: commentId)
    );
    
    _addReply();

  }

  Future<void> _updateRepliesInfo({required int commentId}) async {

    const query = 
    '''
      UPDATE vent_comments_info 
      SET total_replies = total_replies + 1 
      WHERE comment_id = :comment_id
    ''';

    final param = {'comment_id': commentId};

    await executeQuery(query, param);

  }
  
  void _addReply() {

    final now = DateTime.now();
    final formattedTimestamp = FormatDate().formatPostTimestamp(now);

    final newReply = CommentRepliesData(
      reply: replyText,
      repliedBy: repliedBy, 
      replyTimestamp: formattedTimestamp,
      pfpData: getIt.profileProvider.profile.profilePicture
    );

    getIt.commentRepliesProvider.addReply(newReply);

  }

  Future<void> like() async {

    final commentId = await _getCommentId();

    final replyId = await ReplyIdGetter(
      commentId: commentId
    ).getReplyId(username: repliedBy, replyText: replyText);
    // TODO: maybe replied_by & comented_by (from vent_comments_info) can be remove
    const likesInfoParameterQuery = 
      'WHERE reply_id = :reply_id AND liked_by = :liked_by';

    final likesInfoParams = {
      'reply_id': replyId,
      'liked_by': getIt.userProvider.user.username,
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

    final index = repliesProvider.commentReplies.indexWhere(
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
      UPDATE comment_replies_info 
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
      'SELECT 1 FROM replies_likes_info $likesInfoParameterQuery';

    final likesInfoResults = await executeQuery(readLikesInfoQuery, likesInfoParams);

    return likesInfoResults.rows.isNotEmpty;

  }

  Future<void> _updateLikesInfo({
    required bool isUserLikedPost,
    required Map<String, dynamic> likesInfoParams,
    required String likesInfoParameterQuery,
  }) async {

    final query = isUserLikedPost 
      ? 'DELETE FROM replies_likes_info $likesInfoParameterQuery'
      : 'INSERT INTO replies_likes_info (liked_by, reply_id) VALUES (:liked_by, :reply_id)';

    await executeQuery(query, likesInfoParams);

  }

  void _updateCommentLikedValue({
    required int index,
    required bool isUserLikedComment,
  }) {

    if(index != -1) {
      repliesProvider.likeReply(index, isUserLikedComment);
    }

  }

}