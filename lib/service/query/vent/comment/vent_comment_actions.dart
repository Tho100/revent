import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/main.dart';
import 'package:revent/service/query/general/base_query_service.dart';
import 'package:revent/helper/extract_data.dart';
import 'package:revent/service/query/general/comment_id_getter.dart';
import 'package:revent/service/query/general/post_id_getter.dart';

class VentCommentActions extends BaseQueryService {

  final String username;
  final String commentText;
  final String ventCreator;
  final String ventTitle;

  VentCommentActions({
    required this.username,
    required this.commentText,
    required this.ventCreator,
    required this.ventTitle
  });

  final ventCommentProvider = getIt.ventCommentProvider;

  Future<void> delete() async {

    final postId = await PostIdGetter(title: ventTitle, creator: ventCreator).getPostId();

    final commentId = await CommentIdGetter(postId: postId).getCommentId(
      username: username, commentText: commentText
    );

    const query = 
    '''
      DELETE FROM vent_comments_info 
      WHERE commented_by = :commented_by 
        AND comment_id = :comment_id 
        AND post_id = :post_id
    ''';

    final params = {
      'post_id': postId,
      'comment_id': commentId,
      'commented_by': username
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

    final postId = await PostIdGetter(title: ventTitle, creator: ventCreator).getPostId();

    final commentId = await CommentIdGetter(postId: postId).getCommentId(
      username: username, commentText: commentText
    );
    const likesInfoParameterQuery = 
      'WHERE comment_id = :comment_id AND liked_by = :liked_by AND commented_by = :commented_by';

    final likesInfoParams = {
      'comment_id': commentId,
      'liked_by': getIt.userProvider.user.username,
      'commented_by': username,
    };

    final isUserLikedComment = await _isUserLikedComment(
      likesInfoParams: likesInfoParams,
      likesInfoParameterQuery: likesInfoParameterQuery
    );

    await _updateCommentLikes(
      postId: postId, 
      commentId: commentId,
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
      'UPDATE vent_comments_info SET total_likes = total_likes $operationSymbol 1 WHERE post_id = :post_id AND comment_id = :comment_id AND commented_by = :commented_by';

    final ventInfoParams = {
      'post_id': postId,
      'comment_id': commentId,
      'commented_by': username
    };

    await executeQuery(updateLikeValueQuery, ventInfoParams);

  }

  Future<bool> _isUserLikedComment({
    required Map<String, dynamic> likesInfoParams,
    required String likesInfoParameterQuery  
  }) async {

    final readLikesInfoQuery = 
      'SELECT * FROM vent_comments_likes_info $likesInfoParameterQuery';

    final likesInfoResults = await executeQuery(readLikesInfoQuery, likesInfoParams);

    return ExtractData(rowsData: likesInfoResults)
      .extractStringColumn('liked_by').isNotEmpty;

  }

  Future<void> _updateLikesInfo({
    required bool isUserLikedPost,
    required Map<String, dynamic> likesInfoParams,
    required String likesInfoParameterQuery,
  }) async {

    final query = isUserLikedPost 
      ? 'DELETE FROM vent_comments_likes_info $likesInfoParameterQuery'
      : 'INSERT INTO vent_comments_likes_info (liked_by, commented_by, comment_id) VALUES (:liked_by, :commented_by, :comment_id)';

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