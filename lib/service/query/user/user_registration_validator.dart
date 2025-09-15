import 'dart:convert';

import 'package:revent/service/query/general/base_query_service.dart';
import 'package:http/http.dart' as http;
import 'package:revent/shared/api/api_config.dart';
import 'package:revent/shared/api/api_path.dart';

class UserRegistrationValidator extends BaseQueryService {

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

    final response = await http.post(
      ApiConfig.endpoint(ApiPath.verifyUser),
      headers: ApiConfig.jsonHeaders,
      body: jsonEncode({
        'username': username,
        'email': email,
      })
    );

    if (response.statusCode == 200)  {

      final data = jsonDecode(response.body);

      existsConditionMap['username_exists'] = data['username_exists'] as bool;
      existsConditionMap['email_exists'] = data['email_exists'] as bool;

      return existsConditionMap;

    }

    return existsConditionMap;

  }

}