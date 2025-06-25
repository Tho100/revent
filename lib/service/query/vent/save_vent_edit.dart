import 'package:revent/helper/format_date.dart';
import 'package:revent/shared/provider_mixins.dart';
import 'package:revent/service/query/general/base_query_service.dart';
import 'package:revent/service/query/general/post_id_getter.dart';

class SaveVentEdit extends BaseQueryService with UserProfileProviderService, VentProviderService {

  final String title;
  final String newBody;

  SaveVentEdit({
    required this.title,
    required this.newBody,
  });

  Future<void> save() async {

    final postId = activeVentProvider.ventData.postId != 0
      ? activeVentProvider.ventData.postId
      : await PostIdGetter(title: title, creator: userProvider.user.username).getPostId();

    const query = 
      'UPDATE vent_info SET body_text = :new_body WHERE post_id = :post_id';

    final params = {
      'post_id': postId,
      'new_body': newBody
    };

    await executeQuery(query, params).then(
      (_) => _updateLastEdit(isFromArchive: false, postId: postId)
    );

    activeVentProvider.setBody(newBody);

  }

  Future<void> saveArchive() async {

    const query = 
      'UPDATE archive_vent_info SET body_text = :new_body WHERE title = :title AND creator = :creator';

    final params = {
      'title': title,
      'creator': userProvider.user.username,
      'new_body': newBody
    };

    await executeQuery(query, params).then(
      (_) => _updateLastEdit(isFromArchive: true)
    );

    activeVentProvider.setBody(newBody);

  }

  Future<void> _updateLastEdit({required bool isFromArchive, int? postId}) async {

    final dateTimeNow = DateTime.now();

    final query = isFromArchive 
      ? 'UPDATE archive_vent_info SET last_edit = :last_edit WHERE title = :title AND creator = :creator'
      : 'UPDATE vent_info SET last_edit = :last_edit WHERE post_id = :post_id';

    final params = isFromArchive 
      ? {
        'title': title,
        'creator': userProvider.user.username,
        'last_edit': dateTimeNow
        } 
      : {
        'post_id': postId,
        'last_edit': dateTimeNow
        };

    await executeQuery(query, params);

    final formatTimeStamp = FormatDate().formatPostTimestamp(dateTimeNow);

    if (!isFromArchive) {
      activeVentProvider.setLastEdit(formatTimeStamp);
    }

  }

}