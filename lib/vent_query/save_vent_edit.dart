import 'package:get_it/get_it.dart';
import 'package:revent/connection/revent_connect.dart';
import 'package:revent/provider/user_data_provider.dart';

class SaveVentEdit {

  final String title;
  final String body;
  final String newBody;

  SaveVentEdit({
    required this.title,
    required this.body,
    required this.newBody,
  });

  final userData = GetIt.instance<UserDataProvider>();

  Future<void> save() async {

    final conn = await ReventConnect.initializeConnection();

    const query = 
      'UPDATE vent_info SET body_text = :new_body WHERE title = :title AND creator = :creator AND body_text = :body';

    final param = {
      'title': title,
      'creator': userData.user.username,
      'body': body,
      'new_body': newBody
    };

    await conn.execute(query, param);

  }

}