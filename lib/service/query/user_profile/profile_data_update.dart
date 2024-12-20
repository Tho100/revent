import 'dart:convert';
import 'dart:typed_data';

import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/main.dart';
import 'package:revent/service/revent_connection_service.dart';

class ProfileDataUpdate {

  final profileData = getIt.profileProvider;
  final userData = getIt.userProvider;

  Future<void> updateBio({required String bioText}) async {

    final conn = await ReventConnection.connect();

    const query = 'UPDATE user_profile_info SET bio = :bio_value WHERE username = :username';
    
    final params = {
      'bio_value': bioText,
      'username': userData.user.username
    };

    profileData.setBio(bioText);

    await conn.execute(query, params);

  }

  Future<void> updateProfilePicture({required Uint8List picData}) async {

    final conn = await ReventConnection.connect();

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

    final conn = await ReventConnection.connect();

    const query = 'UPDATE user_profile_info SET pronouns = :pronouns WHERE username = :username';

    final params = {
      'pronouns': pronouns,
      'username': userData.user.username
    };

    profileData.setPronouns(pronouns);

    await conn.execute(query, params);

  }

}