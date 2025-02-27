import 'package:revent/helper/providers_service.dart';
import 'package:revent/model/local_storage_model.dart';
import 'package:revent/service/query/general/base_query_service.dart';
import 'package:revent/service/query/user/user_data_getter.dart';

class UserSocials extends BaseQueryService with UserProfileProviderService {

  Future<void> addSocial({
    required String platform, 
    required String handle
  }) async {

    final userId = await UserDataGetter().getUserId();

    const query = 'INSERT INTO user_social_links VALUES (:user_id, :social_handle, :platform)';

    final params = {
      'user_id': userId,
      'social_handle': handle,
      'platform': platform
    };

    await executeQuery(query, params).then((_) {
      LocalStorageModel().setupLocalSocialHandles(
        socialHandles: {platform: handle}
      );
    });

  }

}