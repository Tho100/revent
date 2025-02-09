import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/main.dart';
import 'package:revent/service/query/general/base_query_service.dart';
import 'package:revent/service/query/general/post_id_getter.dart';

class SaveCommentEdit extends BaseQueryService {

  final String originalComment;
  final String newComment;

  SaveCommentEdit({
    required this.originalComment,
    required this.newComment,
  });

  final userData = getIt.userProvider.user;
  final activeVent = getIt.activeVentProvider.ventData;

  Future<void> save() async {

    final postId = await PostIdGetter(title: activeVent.title, creator: activeVent.creator).getPostId();

    const query = 
    '''
      UPDATE comments_info 
      SET comment = :new_comment 
      WHERE post_id = :post_id 
        AND commented_by = :commented_by 
        AND comment = :original_comment
    ''';

    final params = {
      'post_id': postId,
      'original_comment': originalComment,
      'new_comment': newComment,
      'commented_by': userData.username
    };

    await executeQuery(query, params).then((_) {
      getIt.ventCommentProvider.editComment(
        userData.username, newComment, originalComment
      );
    });

  }

}