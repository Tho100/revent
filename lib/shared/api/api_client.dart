import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:revent/shared/api/api_config.dart';
import 'package:revent/shared/api/api_response.dart';

class ApiClient {

  static Future<ApiResponse> post(String path, Map<String, dynamic> data) async {

    final response = await http.post(
      ApiConfig.endpoint(path),
      headers: ApiConfig.jsonHeaders,
      body: jsonEncode(data),
    ).timeout(const Duration(seconds: 25));

    Map<String, dynamic>? decodedBody;

    try {
      decodedBody = jsonDecode(response.body);
    } catch (_) {
      decodedBody = null;
    }

    return ApiResponse(
      statusCode: response.statusCode,
      body: decodedBody,
    );

  }

  static Future<ApiResponse> get(String path, String param) async {

    final uri = ApiConfig.endpoint('$path/$param');

    final response = await http.get(
      uri,
      headers: ApiConfig.jsonHeaders,
    ).timeout(const Duration(seconds: 15));

    Map<String, dynamic>? decodedBody;

    try {
      decodedBody = jsonDecode(response.body);
    } catch (_) {
      decodedBody = null;
    }

    return ApiResponse(
      statusCode: response.statusCode,
      body: decodedBody,
    );
    
  }

}

