import 'package:revent/global/follow_type.dart';
import 'package:revent/helper/data/data_converter.dart';
import 'package:revent/shared/api/api_client.dart';
import 'package:revent/shared/api/api_path.dart';
import 'package:revent/shared/provider_mixins.dart';
import 'package:revent/helper/data/extract_data.dart';

class FollowDataGetter with UserProfileProviderService {

  Future<Map<String, List<dynamic>>> _getUserFollows({
    required FollowType followType,
    required String username
  }) async {
    
    final apiEndPoint = followType == FollowType.followers 
      ? ApiPath.userFollowersGetter 
      : ApiPath.userFollowingGetter;

    final response = await ApiClient.post(apiEndPoint, {
      'current_user': userProvider.user.username,
      'viewed_profile_username': username,
    });

    final profiles = ExtractData(data: response.body!['profiles']);

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

  Future<Map<String, List<dynamic>>> getUserFollowers({required String username}) async {
    return _getUserFollows(username: username, followType: FollowType.followers);
  }

  Future<Map<String, List<dynamic>>> getUserFollowing({required String username}) async {
    return _getUserFollows(username: username, followType: FollowType.following);
  }

  Future<Map<String, List<dynamic>>> getFollowSuggestions() async {

    final response = await ApiClient.get(ApiPath.userFollowSuggestionsGetter, userProvider.user.username);

    final profiles = ExtractData(data: response.body!['profiles']);

    final usernames = profiles.extractColumn<String>('username');
    
    final profilePictures = DataConverter.convertToPfp(
      profiles.extractColumn<String>('profile_picture')
    );

    return {
      'usernames': usernames,
      'profile_pic': profilePictures
    };

  }

}