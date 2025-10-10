import 'package:revent/global/table_names.dart';
import 'package:revent/helper/data_converter.dart';
import 'package:revent/shared/provider_mixins.dart';
import 'package:revent/service/query/general/base_query_service.dart';
import 'package:revent/helper/extract_data.dart';

class FollowsGetter extends BaseQueryService with UserProfileProviderService {

  /// Fetches list of followers/following for given [username] 
  /// also includes their profile picture and whether the current user follows them.

  Future<Map<String, List<dynamic>>> _getFollowing({
    required String followType,
    required String username
  }) async {
    
    final columnName = followType == 'Followers' ? 'follower' : 'following';
    final oppositeColumn = followType == 'Followers' ? 'following' : 'follower';

    final getFollowProfilesQuery = 
    '''
      SELECT DISTINCT
        ufi.$columnName AS username,
        upi.profile_picture AS profile_picture,
        CASE 
          WHEN EXISTS (
            SELECT 1 
            FROM ${TableNames.userFollowsInfo} ufi_inner
            WHERE ufi_inner.follower = :current_user
            AND ufi_inner.following = ufi.$columnName
          )
          THEN 1
          ELSE 0
        END AS is_followed
      FROM ${TableNames.userFollowsInfo} ufi
      JOIN ${TableNames.userProfileInfo} upi ON ufi.$columnName = upi.username
      WHERE ufi.$oppositeColumn = :username
    ''';

    final params = {
      'username': username,
      'current_user': userProvider.user.username
    };

    final followResults = await executeQuery(getFollowProfilesQuery, params);

    final extractedProfiles = ExtractData(rowsData: followResults);

    final followProfileUsernames = extractedProfiles.extractStringColumn('username');

    final profilePictures = DataConverter.convertToPfp(
      extractedProfiles.extractStringColumn('profile_picture')
    );
    
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

  Future<Map<String, List<dynamic>>> _getFollowers({
    required String followType,
    required String username
  }) async {
    
    final columnName = followType == 'Followers' ? 'follower' : 'following';
    final oppositeColumn = followType == 'Followers' ? 'following' : 'follower';

    final getFollowProfilesQuery = 
    '''
      SELECT DISTINCT
        ufi.$columnName AS username,
        upi.profile_picture AS profile_picture,
        CASE 
          WHEN EXISTS (
            SELECT 1 
            FROM ${TableNames.userFollowsInfo} ufi_inner
            WHERE ufi_inner.follower = :current_user
            AND ufi_inner.following = ufi.$columnName
          )
          THEN 1
          ELSE 0
        END AS is_followed
      FROM ${TableNames.userFollowsInfo} ufi
      JOIN ${TableNames.userProfileInfo} upi ON ufi.$columnName = upi.username
      WHERE ufi.$oppositeColumn = :username
    ''';

    final params = {
      'username': username,
      'current_user': userProvider.user.username
    };

    final followResults = await executeQuery(getFollowProfilesQuery, params);

    final extractedProfiles = ExtractData(rowsData: followResults);

    final followProfileUsernames = extractedProfiles.extractStringColumn('username');

    final profilePictures = DataConverter.convertToPfp(
      extractedProfiles.extractStringColumn('profile_picture')
    );
    
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

  Future<Map<String, List<dynamic>>> getFollows({
    required String followType,
    required String username
  }) async {
    
    final columnName = followType == 'Followers' ? 'follower' : 'following';
    final oppositeColumn = followType == 'Followers' ? 'following' : 'follower';

    final getFollowProfilesQuery = 
    '''
      SELECT DISTINCT
        ufi.$columnName AS username,
        upi.profile_picture AS profile_picture,
        CASE 
          WHEN EXISTS (
            SELECT 1 
            FROM ${TableNames.userFollowsInfo} ufi_inner
            WHERE ufi_inner.follower = :current_user
            AND ufi_inner.following = ufi.$columnName
          )
          THEN 1
          ELSE 0
        END AS is_followed
      FROM ${TableNames.userFollowsInfo} ufi
      JOIN ${TableNames.userProfileInfo} upi ON ufi.$columnName = upi.username
      WHERE ufi.$oppositeColumn = :username
    ''';

    final params = {
      'username': username,
      'current_user': userProvider.user.username
    };

    final followResults = await executeQuery(getFollowProfilesQuery, params);

    final extractedProfiles = ExtractData(rowsData: followResults);

    final followProfileUsernames = extractedProfiles.extractStringColumn('username');

    final profilePictures = DataConverter.convertToPfp(
      extractedProfiles.extractStringColumn('profile_picture')
    );
    
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