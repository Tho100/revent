import 'dart:convert';

import 'package:revent/connection/revent_connect.dart';
import 'package:revent/model/extract_data.dart';

class FollowsGetter {

  Future<Map<String, List<dynamic>>> getFollows({
    required String followType, 
    required String username
  }) async {

    final conn = await ReventConnect.initializeConnection();

    final columnName = followType == 'Followers' 
      ? 'follower' : 'following'; 

    final getUsernameQuery = followType == 'Followers' 
      ? 'SELECT $columnName FROM user_follows_info WHERE following = :username'
      : 'SELECT $columnName FROM user_follows_info WHERE follower = :username';

    final followsParam = {'username': username};

    final results = await conn.execute(getUsernameQuery, followsParam);

    final extractedFollows = ExtractData(rowsData: results).extractStringColumn(columnName);

    final profilePicBase64 = await Future.wait(extractedFollows.map((username) async {
      const getProfilePicQuery = 'SELECT profile_picture FROM user_profile_info WHERE username = :username';
      final profilePicParam = {'username': username};

      final results = await conn.execute(getProfilePicQuery, profilePicParam);
      final extractedPfp = ExtractData(rowsData: results).extractStringColumn('profile_picture')[0];
      
      return base64Decode(extractedPfp);
    }));

    return {
      'username': extractedFollows,
      'profile_pic': profilePicBase64
    };

  }

}