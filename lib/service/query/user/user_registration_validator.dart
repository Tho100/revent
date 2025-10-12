import 'package:revent/shared/api/api_client.dart';
import 'package:revent/shared/api/api_path.dart';

class UserRegistrationValidator {

  final String username;
  final String email;

  UserRegistrationValidator({
    required this.username, 
    required this.email
  });

  Future<Map<String, bool>> verifyUsernameAndEmail() async {

    Map<String, bool> existsConditionMap = {
      'username_exists': false,
      'email_exists': false,
    };
  
    final response = await ApiClient.post(ApiPath.verifyUser, {
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

}