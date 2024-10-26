import 'dart:convert';
import 'dart:typed_data';

import 'package:get_it/get_it.dart';
import 'package:revent/connection/revent_connect.dart';
import 'package:revent/model/extract_data.dart';
import 'package:revent/provider/user_data_provider.dart';

class FollowsGetter {

  final userData = GetIt.instance<UserDataProvider>();

  Future<Map<String, List<dynamic>>> getFollows({required String followType}) async {

    final conn = await ReventConnect.initializeConnection();

    final getUsernameQuery = followType == 'Followers' 
      ? 'SELECT * FROM user_follows_info WHERE following = :username'
      : 'SELECT * FROM user_follows_info WHERE follower = :username';

    final followsParam = {'username': userData.user.username};

    final results = await conn.execute(getUsernameQuery, followsParam);

    final columnName = followType == 'Followers' 
      ? 'follower' : 'following'; 

    final extractedFollows = ExtractData(rowsData: results).extractStringColumn(columnName);

    List<Uint8List> profilePicBase64 = [];

    for (var username in extractedFollows) {

      const getProfilePicQuery = 'SELECT profile_picture FROM user_profile_info WHERE username = :username';
      final profilePicParam = {'username': username};

      final results = await conn.execute(getProfilePicQuery, profilePicParam);

      final extractedPfp = ExtractData(rowsData: results).extractStringColumn('profile_picture')[0];
      final decodedBase64 = base64Decode(extractedPfp);

      profilePicBase64.add(decodedBase64);

    }

    return {
      'username': extractedFollows,
      'profile_pic': profilePicBase64
    };

  }

}