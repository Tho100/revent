import 'package:revent/helper/format_date.dart';
import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/helper/providers_service.dart';
import 'package:revent/main.dart';
import 'package:revent/service/query/general/base_query_service.dart';

class SaveVentEdit extends BaseQueryService with UserProfileProviderService {

  final String title;
  final String newBody;

  SaveVentEdit({
    required this.title,
    required this.newBody,
  });

  Future<void> save() async {

    const query = 
      'UPDATE vent_info SET body_text = :new_body WHERE title = :title AND creator = :creator';

    final params = {
      'title': title,
      'creator': userProvider.user.username,
      'new_body': newBody
    };

    await executeQuery(query, params).then(
      (_) async => await _updateLastEdit(isFromArchive: false)
    );
    // TODO: Remove this and use provider-service instead
    getIt.activeVentProvider.setBody(newBody);

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
      (_) async => await _updateLastEdit(isFromArchive: true)
    );

    getIt.activeVentProvider.setBody(newBody);

  }

  Future<void> _updateLastEdit({required bool isFromArchive}) async {

    final dateTimeNow = DateTime.now();

    final query = isFromArchive 
      ? 'UPDATE archive_vent_info SET last_edit = :last_edit WHERE title = :title AND creator = :creator'
      : 'UPDATE vent_info SET last_edit = :last_edit WHERE title = :title AND creator = :creator';

    final params = {
      'title': title,
      'creator': userProvider.user.username,
      'last_edit': dateTimeNow
    };

    await executeQuery(query, params);

    final formatTimeStamp = FormatDate().formatPostTimestamp(dateTimeNow);

    if(!isFromArchive) {
      getIt.activeVentProvider.setLastEdit(formatTimeStamp);
    }

  }

}