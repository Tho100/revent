import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/main.dart';
import 'package:revent/service/query/general/base_query_service.dart';
import 'package:revent/service/query/general/comment_id_getter.dart';
import 'package:revent/service/query/general/post_id_getter.dart';

class CommentActions extends BaseQueryService {

  final String username;
  final String commentText;

  CommentActions({
    required this.username,
    required this.commentText,
  });

  final ventCommentProvider = getIt.ventCommentProvider;
  final activeVent = getIt.activeVentProvider.ventData;

  Future<Map<String, int>> _getIdInfo() async {

    final postId = await PostIdGetter(title: activeVent.title, creator: activeVent.creator).getPostId();

    final commentId = await CommentIdGetter(postId: postId).getCommentId(
      username: username, commentText: commentText
    );

    return {
      'post_id': postId,
      'comment_id': commentId
    };

  }

  Future<void> delete() async {

    final idInfo = await _getIdInfo();

    const query = 
    '''
      DELETE FROM vent_comments_info 
      WHERE comment_id = :comment_id AND post_id = :post_id
    ''';

    final params = {
      'post_id': idInfo['post_id'],
      'comment_id': idInfo['comment_id'],
    };

    await executeQuery(query, params).then(
      (_) => _removeComment()
    );

  }

  void _removeComment() {

    final index = ventCommentProvider.ventComments
      .indexWhere((comment) => comment.commentedBy == username && comment.comment == commentText);

    if(index != -1) {
      ventCommentProvider.deleteComment(index);
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

    final index = ventCommentProvider.ventComments.indexWhere(
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
      UPDATE vent_comments_info 
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
      'SELECT 1 FROM vent_comments_likes_info $likesInfoParameterQuery';

    final likesInfoResults = await executeQuery(readLikesInfoQuery, likesInfoParams);

    return likesInfoResults.rows.isNotEmpty;

  }

  Future<void> _updateLikesInfo({
    required bool isUserLikedPost,
    required Map<String, dynamic> likesInfoParams,
    required String likesInfoParameterQuery,
  }) async {

    final query = isUserLikedPost 
      ? 'DELETE FROM vent_comments_likes_info $likesInfoParameterQuery'
      : 'INSERT INTO vent_comments_likes_info (liked_by, comment_id) VALUES (:liked_by, :comment_id)';

    await executeQuery(query, likesInfoParams);

  }

  void _updateCommentLikedValue({
    required int index,
    required bool isUserLikedComment,
  }) {

    if(index != -1) {
      ventCommentProvider.likeComment(index, isUserLikedComment);
    }

  }

}