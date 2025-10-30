import 'package:revent/shared/api/api_client.dart';
import 'package:revent/shared/api/api_path.dart';

class DeleteAccountData {

  /// Delete all stored information for [username] on account deletion
  /// including non-vault/vault posts, comments, pinned-comment, etc.
// TODO: remove unnecessary parameter, use userProvider.user.username instead
  Future<Map<String, dynamic>> verifyAndDelete({
    required String password, 
    required String username
  }) async {

    final response = await ApiClient.post(ApiPath.deleteUser, {
      'username': username,
      'password': password
    });

    return {
      'status_code': response.statusCode
    };

  }

}