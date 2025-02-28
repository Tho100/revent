import 'package:revent/helper/providers_service.dart';
import 'package:revent/model/local_storage_model.dart';
import 'package:revent/service/query/general/base_query_service.dart';

class UserSocials extends BaseQueryService with UserProfileProviderService {

  final String platform;
  final String handle;

  UserSocials({
    required this.platform, 
    required this.handle
  });

  Future<void> addSocial() async {

    if (userProvider.user.socialHandles.isNotEmpty) {
      await _updateSocialHandles();
      return;
    } 

    const query = 'INSERT INTO user_social_links VALUES (:social_handle, :platform, :username)';

    final params = {
      'social_handle': handle,
      'platform': platform,
      'username': userProvider.user.username
    };

    await executeQuery(query, params).then(
      (_) async => await _updateLocalSocialHandles()
    );

  }

  Future<void> _updateSocialHandles() async {

    const query = 
    '''
      UPDATE TABLE user_social_links
      SET social_handle = :social_handle
      WHERE platform = :platform AND username = :username
    ''';

    final params = {
      'social_handle': handle,
      'platform': platform,
      'username': userProvider.user.username
    };

    await executeQuery(query, params).then(
      (_) async => await _updateLocalSocialHandles()
    );

  }

  Future<void> _updateLocalSocialHandles() async {
    await LocalStorageModel().setupLocalSocialHandles(
      socialHandles: {platform: handle}
    );
  }

}