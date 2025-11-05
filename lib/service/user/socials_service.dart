import 'package:revent/shared/api/api_client.dart';
import 'package:revent/shared/api/api_path.dart';
import 'package:revent/shared/provider_mixins.dart';

class UserSocialsService with UserProfileProviderService {

  final String platform;
  final String handle;

  UserSocialsService({
    required this.platform, 
    required this.handle
  });

  Future<void> addSocial() async {

    await ApiClient.post(ApiPath.updateUserSocials, {
      'social_handle': handle,
      'platform': platform,
      'username': userProvider.user.username,
      'social_exists': (userProvider.user.socialHandles![platform] ?? '').isNotEmpty
    });

  }

}