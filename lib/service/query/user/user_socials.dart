import 'package:revent/shared/provider_mixins.dart';
import 'package:revent/service/query/general/base_query_service.dart';

class UserSocials extends BaseQueryService with UserProfileProviderService {

  final String platform;
  final String handle;

  UserSocials({
    required this.platform, 
    required this.handle
  });

  Future<void> addSocial() async {

    if ((userProvider.user.socialHandles![platform] ?? '').isNotEmpty) {
      await _updateSocialHandles();
      return;
    }

    const query = 
      'INSERT INTO user_social_links (social_handle, platform, username) VALUES (:social_handle, :platform, :username)';

    final params = {
      'social_handle': handle,
      'platform': platform,
      'username': userProvider.user.username
    };

    await executeQuery(query, params);

  }

  Future<void> _updateSocialHandles() async {

    const query = 
    '''
      UPDATE user_social_links
      SET social_handle = :social_handle
      WHERE platform = :platform AND username = :username
    ''';

    final params = {
      'social_handle': handle,
      'platform': platform,
      'username': userProvider.user.username
    };

    await executeQuery(query, params);

  }

}