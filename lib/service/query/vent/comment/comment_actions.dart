import 'package:revent/global/table_names.dart';
import 'package:revent/helper/format_date.dart';
import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/shared/api/api_client.dart';
import 'package:revent/shared/api/api_path.dart';
import 'package:revent/shared/provider/vent/comments_provider.dart';
import 'package:revent/shared/provider_mixins.dart';
import 'package:revent/main.dart';
import 'package:revent/service/query/general/base_query_service.dart';
import 'package:revent/service/query/general/comment_id_getter.dart';

class CommentActions extends BaseQueryService with 
  CommentsProviderService, 
  VentProviderService {

  final String commentedBy;
  final String commentText;

  CommentActions({
    required this.commentedBy, 
    required this.commentText
  });

  Future<Map<String, int>> _getIdInfo() async {

    final commentId = await CommentIdGetter().getCommentId(
      username: commentedBy, commentText: commentText
    );

    return {
      'post_id': activeVentProvider.ventData.postId,
      'comment_id': commentId
    };

  }

  Future<Map<String, dynamic>> sendComment() async {

    final postId = activeVentProvider.ventData.postId;

    final response = await ApiClient.post(ApiPath.createComment, {
      'commented_by': commentedBy,
      'comment': commentText,
      'post_id': postId
    });

    if (response.statusCode == 201) {
      _addComment();
    }

    return {
      'status_code': response.statusCode
    };

  }

  void _addComment() {

    final now = DateTime.now();
    final formattedTimestamp = FormatDate().formatPostTimestamp(now);

    final newComment = CommentsData(
      commentedBy: commentedBy, 
      comment: commentText,
      commentTimestamp: formattedTimestamp,
      pfpData: getIt.profileProvider.profile.profilePicture
    );

    commentsProvider.addComment(newComment);

  }

  Future<Map<String, dynamic>> delete() async {

    final idInfo = await _getIdInfo();

    final response = await ApiClient.deleteById(
      ApiPath.deleteComment, idInfo['comment_id']!
    );

    if (response.statusCode == 204) {
      _removeComment();
    }

    return {
      'status_code': response.statusCode
    };

  }

  void _removeComment() {

    final index = commentsProvider.comments.indexWhere(
      (comment) => comment.commentedBy == commentedBy && comment.comment == commentText
    );

    if (index != -1) {
      commentsProvider.deleteComment(index);
    }

  }

  Future<void> like() async {

    final idInfo = await _getIdInfo();

    const likesInfoQueryParams = 
      'WHERE comment_id = :comment_id AND liked_by = :liked_by';

    final likesInfoParams = {
      'comment_id': idInfo['comment_id'],
      'liked_by': getIt.userProvider.user.username,
    };

    final isUserLikedComment = await _isUserLikedComment(
      likesInfoQueryParams: likesInfoQueryParams,
      likesInfoParams: likesInfoParams
    );

    await _updateCommentLikes(
      postId: idInfo['post_id']!, 
      commentId: idInfo['comment_id']!,
      isUserLikedPost: isUserLikedComment
    );

    await _updateLikesInfo(
      isUserLikedPost: isUserLikedComment,
      likesInfoParams: likesInfoParams,
      likesInfoQueryParams: likesInfoQueryParams
    );

    final index = commentsProvider.comments.indexWhere(
      (comment) => comment.commentedBy == commentedBy && comment.comment == commentText
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
    required String likesInfoQueryParams,
    required Map<String, dynamic> likesInfoParams
  }) async {

    final getLikesInfoQuery = 
      'SELECT 1 FROM ${TableNames.commentsLikesInfo} $likesInfoQueryParams';

    final likesInfoResults = await executeQuery(getLikesInfoQuery, likesInfoParams);

    return likesInfoResults.rows.isNotEmpty;

  }

  Future<void> _updateLikesInfo({
    required bool isUserLikedPost,
    required Map<String, dynamic> likesInfoParams,
    required String likesInfoQueryParams,
  }) async {

    final query = isUserLikedPost 
      ? 'DELETE FROM ${TableNames.commentsLikesInfo} $likesInfoQueryParams'
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