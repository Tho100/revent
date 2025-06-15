import 'package:mysql_client/mysql_client.dart';
import 'package:revent/service/revent_connection_service.dart';

class BaseQueryService {

  Future<IResultSet> executeQuery(String query, [Map<String, dynamic>? params]) async {
    return await ReventConnection.connect().then(
      (conn) => conn.execute(query, params ?? {})
    );
  }

  Future<MySQLConnectionPool> connection() async {
    return await ReventConnection.connect();
  }

}