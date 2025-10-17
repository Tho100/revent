import 'package:revent/shared/api/api_client.dart';
import 'package:revent/shared/api/api_path.dart';
import 'package:revent/shared/provider_mixins.dart';
import 'package:revent/service/query/general/comment_id_getter.dart';

class PinComment with UserProfileProviderService, CommentsProviderService {

  final String username;
  final String commentText;
  
  PinComment({
    required this.username,
    required this.commentText
  });

  Future<Map<String, int>> togglePinComment() async {

    final commentId = await CommentIdGetter().getCommentId(username: username, commentText: commentText);

    final response = await ApiClient.post(ApiPath.pinComment, {
      'pinned_by': userProvider.user.username,
      'comment_id': commentId
    });

    if (response.statusCode == 200) {
      _updateIsPinnedList(response.body!['pinned']);
    }

    return {'status_code': response.statusCode};

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