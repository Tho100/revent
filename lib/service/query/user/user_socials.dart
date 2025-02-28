import 'package:revent/helper/providers_service.dart';
import 'package:revent/model/local_storage_model.dart';
import 'package:revent/service/query/general/base_query_service.dart';

class UserSocials extends BaseQueryService with UserProfileProviderService {

  Future<void> addSocial({
    required String platform, 
    required String handle
  }) async {

    const query = 'INSERT INTO user_social_links VALUES (:social_handle, :platform, :username)';

    final params = {
      'social_handle': handle,
      'platform': platform,
      'username': userProvider.user.username
    };

    await executeQuery(query, params).then((_) {
      LocalStorageModel().setupLocalSocialHandles(
        socialHandles: {platform: handle}
      );
    });

  }

}