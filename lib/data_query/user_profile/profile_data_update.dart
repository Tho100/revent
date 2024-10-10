import 'package:get_it/get_it.dart';
import 'package:revent/connection/revent_connect.dart';
import 'package:revent/provider/profile_data_provider.dart';

class ProfileDataUpdate {

  final String username;

  ProfileDataUpdate({
    required this.username
  });

  final profileData = GetIt.instance<ProfileDataProvider>();

  Future<void> updateBio({required String bioText}) async {

    final conn = await ReventConnect.initializeConnection();

    const query = "UPDATE user_profile_info SET bio = :bio_value WHERE username = :username";
    final params = {
      'bio_value': bioText,
      'username': username
    };

    profileData.setBio(bioText);

    await conn.execute(query, params);

  }

}