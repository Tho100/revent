import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/main.dart';
import 'package:revent/service/revent_connection_service.dart';

class SaveVentEdit {

  final String title;
  final String newBody;

  SaveVentEdit({
    required this.title,
    required this.newBody,
  });

  final userData = getIt.userProvider;

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

    getIt.activeVentProvider.setBody(newBody);

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