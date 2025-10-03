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
      pfpData: profileProvider.profile.profilePicture
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

  Future<Map<String, dynamic>> like() async {

    final idInfo = await _getIdInfo();

    final index = commentsProvider.comments.indexWhere(
      (comment) => comment.commentedBy == commentedBy && comment.comment == commentText
    );

    final isLiked = commentsProvider.comments[index].isCommentLiked;

    final response = await ApiClient.post(ApiPath.likeComment, {
      'comment_id': idInfo['comment_id'],
      'liked_by': userProvider.user.username,
    });

    if (response.statusCode == 200) {
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