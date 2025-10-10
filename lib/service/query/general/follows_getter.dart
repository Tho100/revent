import 'package:revent/helper/data_converter.dart';
import 'package:revent/shared/api/api_client.dart';
import 'package:revent/shared/api/api_path.dart';
import 'package:revent/shared/provider_mixins.dart';
import 'package:revent/service/query/general/base_query_service.dart';
import 'package:revent/helper/extract_data.dart';

class FollowsGetter extends BaseQueryService with UserProfileProviderService {

  Future<Map<String, List<dynamic>>> getFollows({
    required String followType,
    required String username
  }) async {
    
    final apiEndPoint = followType == 'Followers' 
      ? ApiPath.userFollowersGetter 
      : ApiPath.userFollowingGeter;

    final response = await ApiClient.post(apiEndPoint, {
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

}