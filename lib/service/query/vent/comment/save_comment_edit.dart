import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/main.dart';
import 'package:revent/service/query/general/base_query_service.dart';

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
    // TODO: Use post id
    const query = 
      'UPDATE vent_comments_info SET comment = :new_comment WHERE title = :title AND creator = :creator AND commented_by = :commented_by AND comment = :original_comment';

    final params = {
      'title': title,
      'creator': creator,
      'original_comment': originalComment,
      'new_comment': newComment,
      'commented_by': userData.user.username
    };

    await executeQuery(query, params).then(
      (_) async => await _updateLikesInfo(param: params)
    );

    getIt.ventCommentProvider.editComment(
      userData.user.username, newComment, originalComment
    );

  }

  Future<void> _updateLikesInfo({required Map<String, dynamic> param}) async {

    const query = 
      'UPDATE vent_comments_likes_info SET comment = :new_comment WHERE title = :title AND creator = :creator AND commented_by = :commented_by AND comment = :original_comment';

    await executeQuery(query, param);

  }

}