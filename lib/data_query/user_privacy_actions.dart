import 'package:get_it/get_it.dart';
import 'package:revent/connection/revent_connect.dart';
import 'package:revent/provider/user_data_provider.dart';

class UserPrivacyActions {

  final userData = GetIt.instance<UserDataProvider>();

  Future<void> privateAccount({required int isMakePrivate}) async {

    final conn = await ReventConnect.initializeConnection();

    const query = 'UPDATE user_privacy_info SET privated_profile = :new_value WHERE username = :username';

    final param = {
      'username': userData.user.username,
      'new_value': isMakePrivate
    };

    await conn.execute(query, param);

  }

}