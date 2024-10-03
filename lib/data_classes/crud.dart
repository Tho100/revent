import 'package:revent/connection/revent_connect.dart';

class Crud {

  Future<void> execute({
    required String? query,
    required Map<String, dynamic>? params
  }) async {
    final conn = await ReventConnect.initializeConnection();
    await conn.execute(query!, params!);
  }

}