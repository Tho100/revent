import 'package:revent/shared/api/api_client.dart';
import 'package:revent/shared/api/api_path.dart';
import 'package:revent/shared/provider_mixins.dart';

class DeleteAccountData with UserProfileProviderService {

  /// Delete all stored information for [username] on account deletion
  /// including non-vault/vault posts, comments, pinned-comment, etc.

  Future<Map<String, dynamic>> verifyAndDelete({required String password}) async {

    final response = await ApiClient.post(ApiPath.deleteUser, {
      'username': userProvider.user.username,
      'password': password
    });

    return {
      'status_code': response.statusCode
    };

  }

}