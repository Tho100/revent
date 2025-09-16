import 'package:revent/service/query/general/base_query_service.dart';
import 'package:revent/shared/api/api_client.dart';
import 'package:revent/shared/api/api_path.dart';

class UserAuthService extends BaseQueryService {
// TODO: Make these classes static
  Future<Map<String, dynamic>> getLoginAuthentication({
    required String email, 
    required String password
  }) async {

    final response = await ApiClient.post(ApiPath.login, {
      'email': email,
      'password': password,
    });

    return {
      'status_code': response.statusCode,
      'body': response.body,
    };

  }

  Future<bool> verifyUserAuth({
    required String username,
    required String password
  }) async {

    final response = await ApiClient.post(ApiPath.verifyUserAuth, {
      'username': username,
      'password': password
    });

    if (response.statusCode != 200) {
      throw Exception();
    } 

    return response.statusCode == 200;

  }

  Future<bool> updateAccountAuth({
    required String username,
    required String newPassword
  }) async {

    final response = await ApiClient.put(ApiPath.updateUserAuth, {
      'username': username,
      'new_password': newPassword,
    });

    if (response.statusCode != 200) {
      throw Exception();
    }

    return response.statusCode == 200;

  }

}