import 'package:revent/global/table_names.dart';
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

    return response.statusCode == 200;

  }

  Future<void> updateAccountAuth({
    required String username,
    required String newPassword
  }) async {

    const query = 'UPDATE ${TableNames.userInfo} SET password = :new_password WHERE username = :username';
    
    final params = {
      'username': username,
      'new_password': newPassword
    };

    await executeQuery(query, params);

  }

}