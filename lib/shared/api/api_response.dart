class ApiResponse {
  
  final int statusCode;
  final Map<String, dynamic>? body;

  ApiResponse({required this.statusCode, this.body});

}
