import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/main.dart';
import 'package:revent/service/query/general/base_query_service.dart';
import 'package:revent/service/query/general/post_id_getter.dart';

class SaveCommentEdit extends BaseQueryService {

  final String title;
  final String creator;
  final String originalComment;
  final String newComment;

  SaveCommentEdit({
    required this.title,
    required this.creator,
    required this.originalComment,
    required this.newComment,
  });

  final userData = getIt.userProvider;

  Future<void> save() async {

    final postId = await PostIdGetter(title: title, creator: creator).getPostId();

    const query = 
    '''
      UPDATE vent_comments_info 
      SET comment = :new_comment 
      WHERE post_id = :post_id 
        AND commented_by = :commented_by 
        AND comment = :original_comment
    ''';

    final params = {
      'post_id': postId,
      'original_comment': originalComment,
      'new_comment': newComment,
      'commented_by': userData.user.username
    };

    await executeQuery(query, params).then((_) {
      getIt.ventCommentProvider.editComment(
        userData.user.username, newComment, originalComment
      );
    });

  }

}