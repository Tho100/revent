import 'package:mysql_client/mysql_client.dart';
import 'package:revent/service/revent_connection_service.dart';

abstract class BaseQueryService {

  Future<IResultSet> executeQuery(String query, Map<String, dynamic> params) async {
    
    final conn = await ReventConnection.connect();

    return await conn.execute(query, params);

  }

}