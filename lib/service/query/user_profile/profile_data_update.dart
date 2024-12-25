import 'dart:convert';
import 'dart:typed_data';

import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/main.dart';
import 'package:revent/service/query/general/base_query_service.dart';

class ProfileDataUpdate extends BaseQueryService {

  final profileData = getIt.profileProvider;
  final userData = getIt.userProvider;

  Future<void> updateBio({required String bioText}) async {

    const query = 'UPDATE user_profile_info SET bio = :bio_value WHERE username = :username';
    
    final params = {
      'bio_value': bioText,
      'username': userData.user.username
    };

    profileData.profile.bio = bioText;

    await executeQuery(query, params);

  }

  Future<void> updateProfilePicture({required Uint8List picData}) async {

    final toBase64EncodedPfp = const Base64Encoder().convert(picData);

    const query = 
      'UPDATE user_profile_info SET profile_picture = :profile_pic_data WHERE username = :username';

    final params = {
      'profile_pic_data': toBase64EncodedPfp,
      'username': userData.user.username
    };

    profileData.profile.profilePicture = picData;

    await executeQuery(query, params);

  }

  Future<void> updatePronouns({required String pronouns}) async {

    const query = 'UPDATE user_profile_info SET pronouns = :pronouns WHERE username = :username';

    final params = {
      'pronouns': pronouns,
      'username': userData.user.username
    };

    profileData.profile.pronouns = pronouns;

    await executeQuery(query, params);

  }

}