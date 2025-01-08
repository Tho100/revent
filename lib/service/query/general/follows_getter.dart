import 'dart:convert';

import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/main.dart';
import 'package:revent/service/query/general/base_query_service.dart';
import 'package:revent/helper/extract_data.dart';

class FollowsGetter extends BaseQueryService {

  Future<Map<String, List<dynamic>>> getFollows({
    required String followType,
    required String username,
  }) async {
    // TODO: Simplify code
    final columnName = followType == 'Followers' ? 'follower' : 'following';
    final oppositeColumn = followType == 'Followers' ? 'following' : 'follower';

    final getFollowProfilesQuery = 
    ''' 
      SELECT ufi.$columnName AS username, upi.profile_picture AS profile_picture
      FROM user_follows_info ufi
      JOIN user_profile_info upi
      ON ufi.$columnName = upi.username
      WHERE ufi.$oppositeColumn = :username
    ''';

    final followParam = {'username': username};

    final followResults = await executeQuery(getFollowProfilesQuery, followParam);

    final extractedProfiles = ExtractData(rowsData: followResults);

    const getCurrentUserFollowingListQuery = 
      'SELECT following FROM user_follows_info WHERE follower = :current_user';

    final currentUserParam = {'current_user': getIt.userProvider.user.username};

    final currentUserFollowingResults = await executeQuery(getCurrentUserFollowingListQuery, currentUserParam);

    final extractedCurrentUserFollowingList = ExtractData(rowsData: currentUserFollowingResults); 

    final followingListSet = extractedCurrentUserFollowingList.extractStringColumn('following').toSet();

    final followProfileUsernames = extractedProfiles.extractStringColumn('username');

    final profilePictures = extractedProfiles
      .extractStringColumn('profile_picture')
      .map((pfp) => base64Decode(pfp))
      .toList();
    
    final isFollowed = followProfileUsernames.map((username) => followingListSet.contains(username)).toList();

    return {
      'username': followProfileUsernames,
      'profile_pic': profilePictures,
      'is_followed': isFollowed
    };

  }

}