import 'package:revent/helper/providers_service.dart';
import 'package:revent/model/local_storage_model.dart';
import 'package:revent/service/query/general/base_query_service.dart';

class UserSocials extends BaseQueryService with UserProfileProviderService {

  Future<void> addSocial({
    required String platform, 
    required String handle
  }) async {

    const query = 'INSERT INTO user_social_links VALUES (:username, :social_handle, :platform)';

    final params = {
      'username': userProvider.user.username,
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