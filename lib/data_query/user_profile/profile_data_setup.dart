import 'dart:convert';
import 'dart:typed_data';

import 'package:get_it/get_it.dart';
import 'package:revent/connection/revent_connect.dart';
import 'package:revent/model/extract_data.dart';
import 'package:revent/provider/profile_data_provider.dart';

class ProfileDataSetup {

  final profileData = GetIt.instance<ProfileDataProvider>();

  void _initializeProfileInfo(Map<String, dynamic> profileInfo) {

    final totalPosts = profileInfo['total_post'];
    final followers = profileInfo['followers'];
    final following = profileInfo['following'];
    final bio = profileInfo['bio'];
    final profilePic = profileInfo['profile_pic'];

    profileData.setPosts(totalPosts);
    profileData.setFollowers(followers);
    profileData.setFollowing(following);
    profileData.setBio(bio);
    
    final profilePicData = profilePic.toString().isEmpty 
      ? Uint8List(0)
      : base64Decode(profilePic);

    profileData.setProfilePicture(profilePicData);

  }

  Future<void> setup({
    required String username
  }) async {

    final conn = await ReventConnect.initializeConnection();

    // TODO: SIMPLFIY QUERY with SELECT * FROM....
    const query = "SELECT posts, following, followers, bio, profile_picture FROM user_profile_info WHERE username = :username";
    final param = {
      'username': username
    };

    final retrievedInfo = await conn.execute(query, param);

    final extractData = ExtractData(rowsData: retrievedInfo);

    final posts = extractData.extractIntColumn('posts');
    final following = extractData.extractIntColumn('following');
    final followers = extractData.extractIntColumn('followers');
    final bio = extractData.extractStringColumn('bio');
    final profilePic = extractData.extractStringColumn('profile_picture');

    _initializeProfileInfo({
      'total_post': posts[0],
      'following': following[0],
      'followers': followers[0],
      'bio': bio[0],
      'profile_pic': profilePic[0]
    });

  }

}