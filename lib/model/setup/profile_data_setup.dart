import 'dart:convert';
import 'dart:typed_data';

import 'package:get_it/get_it.dart';
import 'package:revent/service/query/user_profile/profile_data_getter.dart';
import 'package:revent/shared/provider/profile/profile_data_provider.dart';

class ProfileDataSetup {

  final profileData = GetIt.instance<ProfileDataProvider>();

  void _setUserProfileInfo({
    required int followers,
    required int following,
    required String bio,
    required String pronouns,
    required String profilePicBase64,
  }) {

    profileData.setFollowers(followers);
    profileData.setFollowing(following);
    profileData.setBio(bio);
    profileData.setPronouns(pronouns);
    
    final profilePicData = profilePicBase64.toString().isEmpty 
      ? Uint8List(0)
      : base64Decode(profilePicBase64);

    profileData.setProfilePicture(profilePicData);

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