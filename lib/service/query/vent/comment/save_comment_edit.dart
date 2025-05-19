import 'package:revent/helper/providers_service.dart';
import 'package:revent/service/query/general/base_query_service.dart';
import 'package:revent/service/query/general/comment_id_getter.dart';

class SaveCommentEdit extends BaseQueryService with 
  UserProfileProviderService, 
  VentProviderService, 
  CommentsProviderService {

  final String originalComment;
  final String newComment;

  SaveCommentEdit({
    required this.originalComment,
    required this.newComment,
  });

  Future<void> save() async {

    final commentId = await CommentIdGetter().getCommentId(
      username: userProvider.user.username, commentText: originalComment
    );

    const query = 
    '''
      UPDATE comments_info 
      SET comment = :new_comment, is_edited = :is_edited
      WHERE comment_id = :comment_id 
    ''';

    final param = {
      'new_comment': newComment,
      'is_edited': true,
      'comment_id': commentId
    };

    await executeQuery(query, param).then((_) {
      commentsProvider.editComment(
        userProvider.user.username, newComment, originalComment
      );
    });

  }

}