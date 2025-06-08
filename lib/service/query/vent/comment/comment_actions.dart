import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/helper/providers_service.dart';
import 'package:revent/main.dart';
import 'package:revent/service/query/general/base_query_service.dart';
import 'package:revent/service/query/general/comment_id_getter.dart';

class CommentActions extends BaseQueryService with CommentsProviderService, VentProviderService {

  final String username;
  final String commentText;

  CommentActions({
    required this.username,
    required this.commentText,
  });

  final activeVent = getIt.activeVentProvider.ventData;

  Future<Map<String, int>> _getIdInfo() async {

    final commentId = await CommentIdGetter().getCommentId(
      username: username, commentText: commentText
    );

    return {
      'post_id': activeVentProvider.ventData.postId,
      'comment_id': commentId
    };

  }

  Future<void> delete() async {

    final idInfo = await _getIdInfo();

    final queries = [
      'DELETE FROM comments_info WHERE comment_id = :comment_id AND post_id = :post_id',
      'UPDATE vent_info SET total_comments = total_comments - 1 WHERE post_id = :post_id'
    ];

    final params = [
      {'post_id': idInfo['post_id'], 'comment_id': idInfo['comment_id']},
      {'post_id': idInfo['post_id']}
    ];

    final conn = await connection();

    await conn.transactional((txn) async {
      for(int i=0; i<queries.length; i++) {
        await txn.execute(queries[i], params[i]);
      }
    }).then((_) => _removeComment());

  }

  void _removeComment() {

    final index = commentsProvider.comments.indexWhere(
      (comment) => comment.commentedBy == username && comment.comment == commentText
    );

    if (index != -1) {
      commentsProvider.deleteComment(index);
    }

  }

  Future<void> like() async {

    final idInfo = await _getIdInfo();

    const likesInfoParameterQuery = 
      'WHERE comment_id = :comment_id AND liked_by = :liked_by';

    final likesInfoParams = {
      'comment_id': idInfo['comment_id'],
      'liked_by': getIt.userProvider.user.username,
    };

    final isUserLikedComment = await _isUserLikedComment(
      likesInfoParams: likesInfoParams,
      likesInfoParameterQuery: likesInfoParameterQuery
    );

    await _updateCommentLikes(
      postId: idInfo['post_id']!, 
      commentId: idInfo['comment_id']!,
      isUserLikedPost: isUserLikedComment
    );

    await _updateLikesInfo(
      isUserLikedPost: isUserLikedComment,
      likesInfoParams: likesInfoParams,
      likesInfoParameterQuery: likesInfoParameterQuery
    );

    final index = commentsProvider.comments.indexWhere(
      (comment) => comment.commentedBy == username && comment.comment == commentText
    );

    _updateCommentLikedValue(
      index: index,
      isUserLikedComment: isUserLikedComment,
    );

  }

  Future<void> _updateCommentLikes({
    required int postId,
    required int commentId,
    required bool isUserLikedPost 
  }) async {

    final operationSymbol = isUserLikedPost ? '-' : '+';

    final updateLikeValueQuery = 
    '''
      UPDATE comments_info 
      SET total_likes = total_likes $operationSymbol 1 
      WHERE post_id = :post_id AND comment_id = :comment_id 
    ''';

    final ventInfoParams = {
      'post_id': postId,
      'comment_id': commentId
    };

    await executeQuery(updateLikeValueQuery, ventInfoParams);

  }

  Future<bool> _isUserLikedComment({
    required Map<String, dynamic> likesInfoParams,
    required String likesInfoParameterQuery  
  }) async {

    final readLikesInfoQuery = 
      'SELECT 1 FROM comments_likes_info $likesInfoParameterQuery';

    final likesInfoResults = await executeQuery(readLikesInfoQuery, likesInfoParams);

    return likesInfoResults.rows.isNotEmpty;

  }

  Future<void> _updateLikesInfo({
    required bool isUserLikedPost,
    required Map<String, dynamic> likesInfoParams,
    required String likesInfoParameterQuery,
  }) async {

    final query = isUserLikedPost 
      ? 'DELETE FROM comments_likes_info $likesInfoParameterQuery'
      : 'INSERT INTO comments_likes_info (liked_by, comment_id) VALUES (:liked_by, :comment_id)';

    await executeQuery(query, likesInfoParams);

  }

  void _updateCommentLikedValue({
    required int index,
    required bool isUserLikedComment,
  }) {

    if (index != -1) {
      commentsProvider.likeComment(index, isUserLikedComment);
    }

  }

}