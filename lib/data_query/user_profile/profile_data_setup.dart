import 'dart:convert';
import 'dart:typed_data';

import 'package:get_it/get_it.dart';
import 'package:revent/connection/revent_connect.dart';
import 'package:revent/model/extract_data.dart';
import 'package:revent/provider/profile_data_provider.dart';

class ProfileDataSetup {

  final profileData = GetIt.instance<ProfileDataProvider>();

  void _initializeProfileInfo({
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

    final conn = await ReventConnect.initializeConnection();

    const query = "SELECT posts, following, followers, bio, profile_picture FROM user_profile_info WHERE username = :username";
    final param = {
      'username': username
    };

    final retrievedInfo = await conn.execute(query, param);

    final extractData = ExtractData(rowsData: retrievedInfo);

    final posts = extractData.extractIntColumn('posts')[0];
    final following = extractData.extractIntColumn('following')[0];
    final followers = extractData.extractIntColumn('followers')[0];
    final bio = extractData.extractStringColumn('bio')[0];
    final profilePic = extractData.extractStringColumn('profile_picture')[0];

    _initializeProfileInfo(
      totalPosts: posts, 
      followers: followers, 
      following: following, 
      bio: bio, 
      profilePicBase64: profilePic
    );

  }

}