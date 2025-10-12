import 'package:revent/service/query/general/base_query_service.dart';
import 'package:revent/helper/extract_data.dart';
import 'package:revent/shared/api/api_client.dart';
import 'package:revent/shared/api/api_path.dart';
// TODO: remove unused basequeryservice, and make functions static
class ProfileDataGetter extends BaseQueryService {

  Future<Map<String, dynamic>> getProfileData({
    required bool isMyProfile,
    required String username
  }) async {

    final response = await ApiClient.post(ApiPath.userProfileInfoGetter, {
      'username': username,
      'profile_type': isMyProfile ? 'my_profile' : 'user_profile'  
    });
    
    final infoData = ExtractData(data: response.body!['info']);

    final following = infoData.extractColumn<int>('following')[0];
    final followers = infoData.extractColumn<int>('followers')[0];
    
    final bio = infoData.extractColumn<String>('bio')[0];
    final pronouns = infoData.extractColumn<String>('pronouns')[0];
    final country = infoData.extractColumn<String>('country')[0];

    final results = {
      'followers': followers, 
      'following': following, 
      'bio': bio,
      'pronouns': pronouns,
      'country': country
    };

    if (isMyProfile) {
      results['profile_pic'] = infoData.extractColumn<String>('profile_picture')[0];
    }

    return results;

  }

}