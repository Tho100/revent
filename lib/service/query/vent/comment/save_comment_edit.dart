import 'package:revent/helper/providers_service.dart';
import 'package:revent/service/query/general/base_query_service.dart';

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

    const query = 
    '''
      UPDATE comments_info 
      SET comment = :new_comment 
      WHERE post_id = :post_id 
        AND commented_by = :commented_by 
        AND comment = :original_comment
    ''';

    final params = {
      'post_id': activeVentProvider.ventData.postId,
      'original_comment': originalComment,
      'new_comment': newComment,
      'commented_by': userProvider.user.username
    };

    await executeQuery(query, params).then((_) {
      commentsProvider.editComment(
        userProvider.user.username, newComment, originalComment
      );
    });

  }

}