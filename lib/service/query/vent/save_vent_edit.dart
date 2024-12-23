import 'package:revent/helper/format_date.dart';
import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/main.dart';
import 'package:revent/service/query/general/base_query_service.dart';

class SaveVentEdit extends BaseQueryService {

  final String title;
  final String newBody;

  SaveVentEdit({
    required this.title,
    required this.newBody,
  });

  final userData = getIt.userProvider;

  Future<void> save() async {

    const query = 
      'UPDATE vent_info SET body_text = :new_body WHERE title = :title AND creator = :creator';
    // TODO: Update to params
    final param = {
      'title': title,
      'creator': userData.user.username,
      'new_body': newBody
    };

    await executeQuery(query, param).then(
      (_) async => await _updateLastEdit()
    );

    getIt.activeVentProvider.setBody(newBody);

  }

  Future<void> saveArchive() async {

    const query = 
      'UPDATE archive_vent_info SET body_text = :new_body WHERE title = :title AND creator = :creator';

    final param = {
      'title': title,
      'creator': userData.user.username,
      'new_body': newBody
    };

    await executeQuery(query, param);

  }

  Future<void> _updateLastEdit() async {

    final dateTimeNow = DateTime.now();

    const query = 
      'UPDATE vent_info SET last_edit = :last_edit WHERE title = :title AND creator = :creator';

    final params = {
      'title': title,
      'creator': userData.user.username,
      'last_edit': dateTimeNow
    };

    await executeQuery(query, params);

    final formatTimeStamp = FormatDate().formatPostTimestamp(dateTimeNow);

    getIt.activeVentProvider.setLastEdit(formatTimeStamp);

  }

}