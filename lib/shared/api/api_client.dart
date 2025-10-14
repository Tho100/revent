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
    ).timeout(const Duration(seconds: 15));

    return ApiResponse(
      statusCode: response.statusCode,
      body: _decodedBody(response.body),
    );

  }

  static Future<ApiResponse> put(String path, Map<String, dynamic> data) async {

    final response = await http.put(
      ApiConfig.endpoint(path),
      headers: ApiConfig.jsonHeaders,
      body: jsonEncode(data)
    ).timeout(const Duration(seconds: 12));

    return ApiResponse(
      statusCode: response.statusCode,
      body: _decodedBody(response.body),
    );
    
  }

  static Future<ApiResponse> get(String path, dynamic param) async {

    final uri = ApiConfig.endpoint('$path/$param');

    final response = await http.get(
      uri,
      headers: ApiConfig.jsonHeaders,
    ).timeout(const Duration(seconds: 12));

    return ApiResponse(
      statusCode: response.statusCode,
      body: _decodedBody(response.body),
    );
    
  }

  static Future<ApiResponse> deleteById(String path, int id) async {

    final uri = ApiConfig.endpoint('$path/$id');

    final response = await http.delete(
      uri,
      headers: ApiConfig.jsonHeaders,
    ).timeout(const Duration(seconds: 10));

    return ApiResponse(
      statusCode: response.statusCode,
      body: _decodedBody(response.body),
    );
    
  }

  static Map<String, dynamic>? _decodedBody(String body) {

    Map<String, dynamic>? decodedBody;

    try {
      decodedBody = jsonDecode(body);
    } catch (_) {
      decodedBody = null;
    }

    return decodedBody;

  }

}