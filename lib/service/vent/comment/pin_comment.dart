import 'package:revent/shared/api/api_client.dart';
import 'package:revent/shared/api/api_path.dart';
import 'package:revent/shared/provider_mixins.dart';
import 'package:revent/service/general/id_service.dart';

class PinComment with UserProfileProviderService, CommentsProviderService, VentProviderService {

  final String username;
  final String commentText;
  
  PinComment({
    required this.username,
    required this.commentText
  });

  Future<Map<String, int>> togglePinComment() async {

    final commentId = await IdService.getCommentId(
      postId: activeVentProvider.ventData.postId,
      username: username, 
      commentText: commentText
    );

    final response = await ApiClient.post(ApiPath.pinComment, {
      'pinned_by': userProvider.user.username,
      'comment_id': commentId
    });

    final index = commentsProvider.comments.indexWhere(
      (comment) => comment.commentedBy == username && comment.comment == commentText
    );

    final isPinned = commentsProvider.comments[index].isPinned;

    if (response.statusCode == 200) {
      _updateCommentPinnedStatus(index, !isPinned);
    }

    return {'status_code': response.statusCode};

  }

  void _updateCommentPinnedStatus(int index, bool doPin) {

    if (index != -1) {
      commentsProvider.pinComment(index, doPin);
    }

  }

}