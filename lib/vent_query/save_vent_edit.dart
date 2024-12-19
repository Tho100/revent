import 'package:get_it/get_it.dart';
import 'package:revent/service/revent_connection_service.dart';
import 'package:revent/provider/user_data_provider.dart';
import 'package:revent/provider/vent/active_vent_provider.dart';

class SaveVentEdit {

  final String title;
  final String newBody;

  SaveVentEdit({
    required this.title,
    required this.newBody,
  });

  final userData = GetIt.instance<UserDataProvider>();

  Future<void> save() async {

    final conn = await ReventConnection.connect();

    const query = 
      'UPDATE vent_info SET body_text = :new_body WHERE title = :title AND creator = :creator';

    final param = {
      'title': title,
      'creator': userData.user.username,
      'new_body': newBody
    };

    await conn.execute(query, param);

    GetIt.instance<ActiveVentProvider>().setBody(newBody);

  }

  Future<void> saveArchive() async {

    final conn = await ReventConnection.connect();

    const query = 
      'UPDATE archive_vent_info SET body_text = :new_body WHERE title = :title AND creator = :creator';

    final param = {
      'title': title,
      'creator': userData.user.username,
      'new_body': newBody
    };

    await conn.execute(query, param);

  }

}