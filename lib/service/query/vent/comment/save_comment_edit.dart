import 'package:revent/shared/api/api_client.dart';
import 'package:revent/shared/api/api_path.dart';
import 'package:revent/shared/provider_mixins.dart';
import 'package:revent/service/query/general/id_service.dart';

class SaveCommentEdit with 
  UserProfileProviderService, 
  VentProviderService, 
  CommentsProviderService {

  final String originalComment;
  final String newComment;

  SaveCommentEdit({
    required this.originalComment,
    required this.newComment
  });

  Future<Map<String, dynamic>> save() async {

    final commentId = await IdService.getCommentId(
      postId: activeVentProvider.ventData.postId,
      username: userProvider.user.username, 
      commentText: originalComment
    );

    final response = await ApiClient.post(ApiPath.editComment, {
      'new_comment': newComment,
      'comment_id': commentId
    });

    if (response.statusCode == 200) {
      commentsProvider.editComment(userProvider.user.username, newComment, originalComment);
    }

    return {
      'status_code': response.statusCode
    };

  }

}