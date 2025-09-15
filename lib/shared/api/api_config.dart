import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {

  static final baseUrl = dotenv.env['api_base_url'] ?? 'http://10.0.2.2:3000';

  static const jsonHeaders = {'Content-Type': 'application/json'};

  static Uri endpoint(String path) => Uri.parse('$baseUrl$path');

}