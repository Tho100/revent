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

  Future<int> _getUserId() async {

    const query = 'SELECT user_id FROM user_information WHERE username = :username';

    final param = {'username': userProvider.user.username};

    final results = await executeQuery(query, param);

    return ExtractData(rowsData: results).extractIntColumn('user_id')[0];

  }

}