import 'package:revent/helper/format_date.dart';
import 'package:revent/shared/api/api_client.dart';
import 'package:revent/shared/api/api_path.dart';
import 'package:revent/shared/provider/vent/comments_provider.dart';
import 'package:revent/shared/provider_mixins.dart';
import 'package:revent/service/query/general/base_query_service.dart';
import 'package:revent/service/query/general/comment_id_getter.dart';

class CommentActions extends BaseQueryService with 
  CommentsProviderService, 
  VentProviderService,
  UserProfileProviderService {

  String commentedBy;
  String commentText;

  CommentActions({
    required this.commentedBy, 
    required this.commentText
  });

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
      pfpData: profileProvider.profile.profilePicture
    );

    commentsProvider.addComment(newComment);

  }

  Future<Map<String, dynamic>> delete() async {

    final commentId = await CommentIdGetter().getCommentId(
      username: commentedBy, commentText: commentText
    );

    final response = await ApiClient.deleteById(
      ApiPath.deleteComment, commentId
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

  Future<Map<String, dynamic>> toggleLikeComment() async {

    final commentId = await CommentIdGetter().getCommentId(
      username: commentedBy, commentText: commentText
    );

    final response = await ApiClient.post(ApiPath.likeComment, {
      'comment_id': commentId,
      'liked_by': userProvider.user.username,
    });

    if (response.statusCode == 200) {

      final index = commentsProvider.comments.indexWhere(
        (comment) => comment.commentedBy == commentedBy && comment.comment == commentText
      );

      final isLiked = commentsProvider.comments[index].isCommentLiked;

      _updateCommentLikedValue(
        index: index,
        liked: isLiked,
      );

    }

    return {
      'status_code': response.statusCode
    };

  }

  void _updateCommentLikedValue({
    required int index,
    required bool liked,
  }) {

    if (index != -1) {
      commentsProvider.likeComment(index, liked);
    }

  }

}