import 'dart:convert';

import 'package:revent/helper/providers_service.dart';
import 'package:revent/service/query/general/base_query_service.dart';
import 'package:revent/helper/extract_data.dart';

class FollowsGetter extends BaseQueryService with UserProfileProviderService {

  Future<Map<String, List<dynamic>>> getFollows({
    required String followType,
    required String username,
  }) async {

    final columnName = followType == 'Followers' ? 'follower' : 'following';
    final oppositeColumn = followType == 'Followers' ? 'following' : 'follower';

    final getFollowProfilesQuery = 
    '''
      SELECT 
        ufi.$columnName AS username,
        upi.profile_picture AS profile_picture,
        CASE 
          WHEN EXISTS (
            SELECT 1 
            FROM user_follows_info ufi_inner
            WHERE ufi_inner.follower = :current_user
            AND ufi_inner.following = ufi.$columnName
          )
          THEN 1
          ELSE 0
        END AS is_followed
      FROM user_follows_info ufi
      JOIN user_profile_info upi ON ufi.$columnName = upi.username
      WHERE ufi.$oppositeColumn = :username
    ''';

    final params = {
      'username': username,
      'current_user': userProvider.user.username
    };

    final followResults = await executeQuery(getFollowProfilesQuery, params);

    final extractedProfiles = ExtractData(rowsData: followResults);

    final followProfileUsernames = extractedProfiles.extractStringColumn('username');

    final profilePictures = extractedProfiles
      .extractStringColumn('profile_picture')
      .map((pfp) => base64Decode(pfp))
      .toList();
    
    final isFollowed = extractedProfiles
      .extractIntColumn('is_followed')
      .map((value) => value == 1)
      .toList();

    return {
      'username': followProfileUsernames,
      'profile_pic': profilePictures,
      'is_followed': isFollowed
    };

  }

}