import 'package:get_it/get_it.dart';
import 'package:revent/connection/revent_connect.dart';
import 'package:revent/provider/profile_data_provider.dart';

class ProfileDataUpdate {

  final String username;

  ProfileDataUpdate({
    required this.username
  });

  final profileDataProvider = GetIt.instance<ProfileDataProvider>();

  Future<void> updateBio({required String bioText}) async {

    final conn = await ReventConnect.initializeConnection();

    const query = "UPDATE user_profile_info SET bio = :bio_value WHERE username = :username";
    final params = {
      'bio_value': bioText,
      'username': username
    };

    // TODOO: Read profile data on startup and load it to provider data,
    // TODO: On bio-update, update the bio-provider data 

    await conn.execute(query, params);

  }

}