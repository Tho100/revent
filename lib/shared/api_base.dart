import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiBase {

  final baseUrl = dotenv.env['api_base_url'] ?? 'http://10.0.2.2:3000';

}