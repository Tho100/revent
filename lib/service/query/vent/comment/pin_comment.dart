import 'package:revent/helper/providers_service.dart';
import 'package:revent/service/query/general/base_query_service.dart';
import 'package:revent/service/query/general/comment_id_getter.dart';

class PinComment extends BaseQueryService with UserProfileProviderService, CommentsProviderService {

  final String username;
  final String commentText;
  
  PinComment({
    required this.username,
    required this.commentText
  });

  Future<void> pin() async {

    final commentId = await CommentIdGetter().getCommentId(username: username, commentText: commentText);

    const query = 'INSERT INTO pinned_comments_info (pinned_by, comment_id) VALUES (:pinned_by, :comment_id)';

    final params = {
      'pinned_by': userProvider.user.username,
      'comment_id': commentId
    };

    await executeQuery(query, params).then(
      (_) => _updateIsPinnedList(true)
    );

  }

  Future<void> unpin() async {

    final commentId = await CommentIdGetter().getCommentId(username: username, commentText: commentText);

    const query = 'DELETE FROM pinned_comments_info WHERE comment_id = :post_id AND pinned_by = :pinned_by';

    final params = {
      'pinned_by': userProvider.user.username,
      'post_id': commentId
    };

    await executeQuery(query, params).then(
      (_) => _updateIsPinnedList(false)
    );

  }

  void _updateIsPinnedList(bool isPin) {

    final index = commentsProvider.comments.indexWhere(
      (comment) => comment.commentedBy == username && comment.comment == commentText
    );

    if (index != -1) {
      commentsProvider.pinComment(isPin, index);
    }

  }

}