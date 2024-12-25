import 'dart:convert';
import 'dart:typed_data';

import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/main.dart';
import 'package:revent/service/query/user_profile/profile_data_getter.dart';
import 'package:revent/shared/provider/profile/profile_provider.dart';

class ProfileDataSetup {

  void _setUserProfileInfo({
    required int followers,
    required int following,
    required String bio,
    required String pronouns,
    required String profilePicBase64,
  }) {

    final profileData = getIt.profileProvider;

    final profilePicture = profilePicBase64.toString().isEmpty 
      ? Uint8List(0)
      : base64Decode(profilePicBase64);

    final profileData1 = ProfileData(
      bio: bio, 
      pronouns: pronouns, 
      profilePicture: profilePicture, 
      followers: followers, 
      following: following
    );

    profileData.setProfile(profileData1);

  }

  Future<void> setup({
    required String username
  }) async {

    final getProfileData = await ProfileDataGetter().getProfileData(
      isMyProfile: true, username: username
    );

    _setUserProfileInfo(
      followers: getProfileData['followers'], 
      following: getProfileData['following'], 
      bio: getProfileData['bio'], 
      pronouns: getProfileData['pronouns'],
      profilePicBase64: getProfileData['profile_pic']
    );

  }

}