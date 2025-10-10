import 'package:revent/global/table_names.dart';
import 'package:revent/helper/data_converter.dart';
import 'package:revent/shared/api/api_client.dart';
import 'package:revent/shared/api/api_path.dart';
import 'package:revent/shared/provider_mixins.dart';
import 'package:revent/service/query/general/base_query_service.dart';
import 'package:revent/helper/extract_data.dart';

class FollowsGetter extends BaseQueryService with UserProfileProviderService {

  /// Fetches list of followers/following for given [username] 
  /// also includes their profile picture and whether the current user follows them.

  Future<Map<String, List<dynamic>>> _getFollowing({required String username}) async {

    const getFollowProfilesQuery = 
    '''
      SELECT DISTINCT
        ufi.following AS username,
        upi.profile_picture AS profile_picture,
        CASE 
          WHEN EXISTS (
            SELECT 1 
            FROM ${TableNames.userFollowsInfo} ufi_inner
            WHERE ufi_inner.follower = :current_user
            AND ufi_inner.following = ufi.following
          )
          THEN 1
          ELSE 0
        END AS is_followed
      FROM ${TableNames.userFollowsInfo} ufi
      JOIN ${TableNames.userProfileInfo} upi ON ufi.following = upi.username
      WHERE ufi.follower = :username
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

  Future<Map<String, List<dynamic>>> _getFollowers({required String username}) async {
    
    final response = await ApiClient.post(ApiPath.userFollowersGetter, {
      'current_user': userProvider.user.username,
      'viewed_profile_username': username,
    });

    final profiles = ExtractData(rowsData: response.body!['profiles']);

    final followProfileUsernames = profiles.extractColumn<String>('username');

    final profilePictures = DataConverter.convertToPfp(
      profiles.extractColumn<String>('profile_picture')
    );
    
    final isFollowed = profiles
      .extractColumn<int>('is_followed')
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
    
    return followType == 'Followers' 
      ? _getFollowers(username: username)
      : _getFollowers(username: username);

  }

}