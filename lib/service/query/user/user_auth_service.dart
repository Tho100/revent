import 'dart:convert';

import 'package:revent/global/table_names.dart';
import 'package:revent/service/query/general/base_query_service.dart';
import 'package:http/http.dart' as http;
import 'package:revent/shared/api_base.dart';

class UserAuthService extends BaseQueryService {

  Future<Map<String, dynamic>> getLoginAuthentication({
    required String email, 
    required String password
  }) async {

    final response = await http.post(
      Uri.parse('${ApiBase().baseUrl}/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      })
    );

    return {
      'status_code': response.statusCode,
      'body': jsonDecode(response.body),
    };

  }

  Future<String> getAccountAuthentication({required String username}) async {

    const query = 'SELECT password FROM ${TableNames.userInfo} WHERE username = :username';

    final param = {'username': username};

    final results = await executeQuery(query, param);

    return results.rows.last.assoc()['password']!;

  }

  Future<void> updateAccountAuth({
    required String username,
    required String newPasswordHash
  }) async {

    const query = 'UPDATE ${TableNames.userInfo} SET password = :new_password WHERE username = :username';
    
    final params = {
      'username': username,
      'new_password': newPasswordHash
    };

    await executeQuery(query, params);

  }

}