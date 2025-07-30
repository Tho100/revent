import 'package:revent/global/table_names.dart';
import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/shared/provider_mixins.dart';
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

  Future<Map<String, int>> _getIdInfo() async {

    final commentId = await CommentIdGetter().getCommentId(
      username: username, commentText: commentText
    );

    return {
      'post_id': activeVentProvider.ventData.postId,
      'comment_id': commentId
    };

  }

  Future<void> createCommentTransaction() async {

    final postId = activeVentProvider.ventData.postId;

    final conn = await connection();

    await conn.transactional((txn) async {

      await txn.execute(
        'INSERT INTO ${TableNames.commentsInfo} (commented_by, comment, post_id) VALUES (:commented_by, :comment, :post_id)',
        {
          'commented_by': username,
          'comment': commentText,
          'post_id': postId
        },
      );

      await txn.execute(
        'UPDATE ${TableNames.ventInfo} SET total_comments = total_comments + 1 WHERE post_id = :post_id',
        {'post_id': postId}
      );

    });

  }

  Future<void> delete() async {

    final idInfo = await _getIdInfo();

    final conn = await connection();

    await conn.transactional((txn) async {
     
      await txn.execute(
        '''
          DELETE ${TableNames.commentsLikesInfo}
            ${TableNames.commentsLikesInfo}
          INNER JOIN ${TableNames.commentsInfo}
            ON ${TableNames.commentsLikesInfo}.comment_id = ${TableNames.commentsInfo}.comment_id
          WHERE ${TableNames.commentsInfo}.post_id = :post_id
        ''',
        {'post_id': idInfo['post_id']}
      );

      await txn.execute(
        'DELETE ${TableNames.commentsInfo} WHERE comment_id = :comment_id AND post_id = :post_id ',
        {
          'post_id': idInfo['post_id'], 
          'comment_id': idInfo['comment_id']
        },
      );

      await txn.execute(
        'UPDATE ${TableNames.ventInfo} SET total_comments = total_comments - 1 WHERE post_id = :post_id',
        {'post_id': idInfo['post_id']}
      );

    }).then(
      (_) => _removeComment()
    );

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
      UPDATE ${TableNames.commentsInfo} 
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
      'SELECT 1 ${TableNames.commentsLikesInfo} $likesInfoParameterQuery';

    final likesInfoResults = await executeQuery(readLikesInfoQuery, likesInfoParams);

    return likesInfoResults.rows.isNotEmpty;

  }

  Future<void> _updateLikesInfo({
    required bool isUserLikedPost,
    required Map<String, dynamic> likesInfoParams,
    required String likesInfoParameterQuery,
  }) async {

    final query = isUserLikedPost 
      ? 'DELETE ${TableNames.commentsLikesInfo} $likesInfoParameterQuery'
      : 'INSERT INTO ${TableNames.commentsLikesInfo} (liked_by, comment_id) VALUES (:liked_by, :comment_id)';

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