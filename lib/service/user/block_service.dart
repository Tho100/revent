import 'package:revent/helper/data/extract_data.dart';
import 'package:revent/helper/data/data_converter.dart';
import 'package:revent/shared/api/api_client.dart';
import 'package:revent/shared/api/api_path.dart';
import 'package:revent/shared/provider_mixins.dart';

class UserBlockService with UserProfileProviderService {

  final String username;

  UserBlockService({required this.username});

  Future<Map<String, dynamic>> getBlockedAccounts() async {

    final response = await ApiClient.get(ApiPath.userBlockedAccountsGetter, username);

    final blockedAccounts = ExtractData(data: response.body!['blocked_accounts']);

    final usernames = blockedAccounts.extractColumn<String>('username');

    final profilePictures = DataConverter.convertToPfp(
      blockedAccounts.extractColumn<String>('profile_picture')
    );
    
    return {
      'username': usernames,
      'profile_pic': profilePictures
    };

  }

  Future<bool> getIsAccountBlocked() async {

    final response = await ApiClient.post(ApiPath.userBlockedStatusGetter, {
      'current_user': userProvider.user.username,
      'viewed_profile_username': username,
    });

    return response.body!['is_blocked'] as bool;

  }
  
}