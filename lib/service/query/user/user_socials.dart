import 'package:revent/helper/extract_data.dart';
import 'package:revent/helper/providers_service.dart';
import 'package:revent/model/local_storage_model.dart';
import 'package:revent/service/query/general/base_query_service.dart';

class UserSocials extends BaseQueryService with UserProfileProviderService {

  Future<void> addSocial({
    required String platform, 
    required String handle
  }) async {

    final userId = await _getUserId();

    const query = 'INSERT INTO user_social_links VALUES (:user_id, :social_handle, :platform)';

    final params = {
      'user_id': userId,
      'social_handle': handle,
      'platform': platform
    };

    await executeQuery(query, params).then((_) {
      LocalStorageModel().setupLocalSocialHandles(socialHandles: {
        platform: handle
      });
    });

  }

  Future<Map<String, String>> getSocialHandles({required String username}) async {

    final userId = await _getUserId(username: username);

    const query = 'SELECT platform, social_handle FROM user_social_links WHERE user_id = :user_id';

    final param = {'user_id': userId};
    
    final results = await executeQuery(query, param);

    if (results.isEmpty) {
      return {};
    }

    final extractedData = ExtractData(rowsData: results);

    final platforms = extractedData.extractStringColumn('platform');
    final handles = extractedData.extractStringColumn('social_handle');

    final Map<String, String> socialHandles = {};
    
    for (int i = 0; i < platforms.length; i++) {
      if (handles[i].isNotEmpty) {
        socialHandles[platforms[i]] = handles[i];
      }
    }

    return socialHandles;

  }

  Future<int> _getUserId({String? username}) async {

    const query = 'SELECT user_id FROM user_information WHERE username = :username';

    final param = {'username': username ?? userProvider.user.username};

    final results = await executeQuery(query, param);

    return ExtractData(rowsData: results).extractIntColumn('user_id')[0];

  }

}