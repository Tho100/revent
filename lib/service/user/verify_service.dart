import 'package:revent/shared/api/api_client.dart';
import 'package:revent/shared/api/api_path.dart';

class UserVerifyService {

  Future<Map<String, bool>> usernameOrEmailExists({
    required String username, 
    required String email
  }) async {

    Map<String, bool> existsConditionMap = {
      'username_exists': false,
      'email_exists': false,
    };
  
    final response = await ApiClient.post(ApiPath.verifyUserAvailability, {
      'username': username,
      'email': email,
    });

    if (response.statusCode == 200)  {

      existsConditionMap['username_exists'] = response.body!['username_exists'] as bool;
      existsConditionMap['email_exists'] = response.body!['email_exists'] as bool;

      return existsConditionMap;

    }

    return existsConditionMap;

  }

  Future<bool> userExists({required String username}) async {

    final response = await ApiClient.get(ApiPath.verifyUser, username);

    return response.body!['user_exists'] as bool;

  }

}