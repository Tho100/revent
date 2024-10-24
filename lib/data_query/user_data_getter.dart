import 'package:mysql_client/mysql_client.dart';
import 'package:revent/model/extract_data.dart';

class UserDataGetter {

  Future<String?> getUsername({
    required MySQLConnectionPool conn,
    required String email
  }) async {

    const query = "SELECT username FROM user_information WHERE email = :email";
    final params = {'email': email};
    
    final results = await conn.execute(query, params);

    if(results.rows.isEmpty) {
      return null;
    }

    return results.rows.last.assoc()['username'];

  }

  Future<Map<String, dynamic>> getUserStartupInfo({
    required MySQLConnectionPool conn,
    required String email
  }) async {

    const query = "SELECT username, plan FROM user_information WHERE email = :email";
    final param = {'email': email};
    
    final results = await conn.execute(query, param);

    final extractedData = ExtractData(rowsData: results);

    final username = extractedData.extractStringColumn('username')[0];
    final plan = extractedData.extractStringColumn('plan')[0];

    return {
      'username': username,
      'plan': plan,
    };

  }

  Future<String> getAccountAuthentication({
    required MySQLConnectionPool conn,
    required String username
  }) async {

    const query = "SELECT password FROM user_information WHERE username = :username";
    final params = {'username': username};

    final results = await conn.execute(query, params);

    return results.rows.last.assoc()['password']!;

  }
  
}