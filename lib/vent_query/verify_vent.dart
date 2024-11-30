import 'package:get_it/get_it.dart';
import 'package:revent/connection/revent_connect.dart';
import 'package:revent/provider/user_data_provider.dart';

class VerifyVent {
  
  final String title;

  VerifyVent({required this.title});

  final userData = GetIt.instance<UserDataProvider>();

  Future<bool> ventIsAlreadyExists() async {

    final conn = await ReventConnect.initializeConnection();

    const query = 'SELECT * FROM vent_info WHERE creator = :creator AND title = :title';

    final param = {
      'title': title,
      'creator': userData.user.username
    };

    final results = await conn.execute(query, param);

    return results.rows.isNotEmpty;

  }

}