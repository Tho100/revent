import 'dart:convert';
import 'dart:typed_data';

import 'package:get_it/get_it.dart';
import 'package:revent/data_query/user_profile/profile_data_getter.dart';
import 'package:revent/provider/profile_data_provider.dart';

class ProfileDataSetup {

  final profileData = GetIt.instance<ProfileDataProvider>();

  void _setUserProfileInfo({
    required int totalPosts,
    required int followers,
    required int following,
    required String bio,
    required String profilePicBase64,
  }) {

    profileData.setPosts(totalPosts);
    profileData.setFollowers(followers);
    profileData.setFollowing(following);
    profileData.setBio(bio);
    
    final profilePicData = profilePicBase64.toString().isEmpty 
      ? Uint8List(0)
      : base64Decode(profilePicBase64);

    profileData.setProfilePicture(profilePicData);

  }

  Future<void> setup({
    required String username
  }) async {

    final getProfileData = await ProfileDataGetter().getData(username: username);

    _setUserProfileInfo(
      totalPosts: getProfileData['posts'], 
      followers: getProfileData['followers'], 
      following: getProfileData['following'], 
      bio: getProfileData['bio'], 
      profilePicBase64: getProfileData['profile_pic']
    );

  }

}