import 'dart:convert';
import 'dart:typed_data';

import 'package:get_it/get_it.dart';
import 'package:revent/connection/revent_connect.dart';
import 'package:revent/provider/profile_data_provider.dart';
import 'package:revent/provider/user_data_provider.dart';

class ProfileDataUpdate {

  final profileData = GetIt.instance<ProfileDataProvider>();
  final userData = GetIt.instance<UserDataProvider>();

  Future<void> updateBio({required String bioText}) async {

    final conn = await ReventConnect.initializeConnection();

    const query = 'UPDATE user_profile_info SET bio = :bio_value WHERE username = :username';
    
    final params = {
      'bio_value': bioText,
      'username': userData.user.username
    };

    profileData.setBio(bioText);

    await conn.execute(query, params);

  }

  Future<void> updateProfilePicture({required Uint8List picData}) async {

    final conn = await ReventConnect.initializeConnection();

    final toBase64EncodedPfp = const Base64Encoder().convert(picData);

    const query = 'UPDATE user_profile_info SET profile_picture = :profile_pic_data WHERE username = :username';

    final params = {
      'profile_pic_data': toBase64EncodedPfp,
      'username': userData.user.username
    };

    profileData.setProfilePicture(picData);

    await conn.execute(query, params);

  }

  Future<void> updatePronouns({required String pronouns}) async {

    final conn = await ReventConnect.initializeConnection();

    const query = 'UPDATE user_profile_info SET pronouns = :pronouns WHERE username = :username';

    final params = {
      'pronouns': pronouns,
      'username': userData.user.username
    };

    profileData.setPronouns(pronouns);

    await conn.execute(query, params);

  }

}