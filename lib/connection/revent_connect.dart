import 'package:mysql_client/mysql_client.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ReventConnect {

  static final _dbClusterFsc = MySQLConnectionPool(
    host: dotenv.env['domain']!,
    port: int.tryParse(dotenv.env['port']!)!,
    userName: dotenv.env['name']!,
    password: dotenv.env['password']!,
    databaseName: dotenv.env['database']!,
    maxConnections: 8,
  );

  static Future<MySQLConnectionPool> initializeConnection() async {
    return _dbClusterFsc;
  }

}