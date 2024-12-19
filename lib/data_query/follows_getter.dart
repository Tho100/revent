import 'dart:convert';

import 'package:revent/service/revent_connection_service.dart';
import 'package:revent/model/extract_data.dart';

class FollowsGetter {

  Future<Map<String, List<dynamic>>> getFollows({
    required String followType,
    required String username,
  }) async {

    final conn = await ReventConnection.connect();

    final columnName = followType == 'Followers' ? 'follower' : 'following';
    final oppositeColumn = followType == 'Followers' ? 'following' : 'follower';

    final getFollowsWithProfilePicQuery = 
    '''
      SELECT ufi.$columnName AS username, upi.profile_picture AS profile_picture
      FROM user_follows_info ufi
      JOIN user_profile_info upi
      ON ufi.$columnName = upi.username
      WHERE ufi.$oppositeColumn = :username
    ''';

    final params = {'username': username};

    final results = await conn.execute(getFollowsWithProfilePicQuery, params);

    final extractedData = ExtractData(rowsData: results);

    final usernames = extractedData.extractStringColumn('username');
    
    final profilePictures = extractedData
      .extractStringColumn('profile_picture')
      .map((pfp) => base64Decode(pfp))
      .toList();

    return {
      'username': usernames,
      'profile_pic': profilePictures,
    };

  }


}