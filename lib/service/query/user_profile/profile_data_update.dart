import 'dart:convert';
import 'dart:typed_data';

import 'package:revent/helper/providers_service.dart';
import 'package:revent/service/query/general/base_query_service.dart';

class ProfileDataUpdate extends BaseQueryService with UserProfileProviderService {

  Future<void> updateBio({required String bioText}) async {

    const query = 'UPDATE user_profile_info SET bio = :bio_value WHERE username = :username';
    
    final params = {
      'bio_value': bioText,
      'username': userProvider.user.username
    };

    await executeQuery(query, params).then(
      (_) => profileProvider.profile.bio = bioText
    );

  }

  Future<void> updateProfilePicture({required Uint8List picData}) async {

    final toBase64EncodedPfp = const Base64Encoder().convert(picData);

    const query = 
      'UPDATE user_profile_info SET profile_picture = :profile_pic_data WHERE username = :username';

    final params = {
      'profile_pic_data': toBase64EncodedPfp,
      'username': userProvider.user.username
    };

    profileProvider.profile.profilePicture = picData; // TODO: Remove this

    await executeQuery(query, params).then(
      (_) => profileProvider.profile.profilePicture = picData
    );

  }

  Future<void> removeProfilePicture() async {

    const query = 
      'UPDATE user_profile_info SET profile_picture = :profile_pic_data WHERE username = :username';

    final params = {
      'profile_pic_data': '',
      'username': userProvider.user.username
    };

    await executeQuery(query, params).then(
      (_) => profileProvider.profile.profilePicture = Uint8List(0)
    );

  }

  Future<void> updatePronouns({required String pronouns}) async {

    const query = 'UPDATE user_profile_info SET pronouns = :pronouns WHERE username = :username';

    final params = {
      'pronouns': pronouns,
      'username': userProvider.user.username
    };

    profileProvider.profile.pronouns = pronouns; // TODO: Remove this

    await executeQuery(query, params).then(
      (_) => profileProvider.profile.pronouns = pronouns
    );

  }

}