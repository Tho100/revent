import 'package:mysql_client/mysql_client.dart';

class UserDataGetter {

  Future<String?> getUsername({
    required MySQLConnectionPool conn,
    required String? email
  }) async {

    const query = "SELECT username FROM user_information WHERE email = :email";
    final params = {'email': email};
    
    final results = await conn.execute(query, params);

    if(results.rows.isEmpty) {
      return null;
    }

    return results.rows.last.assoc()['username'];

  }

  Future<List<String?>> getAccountTypeAndUsername({
    required MySQLConnectionPool conn,
    required String? email
  }) async {

    const getUsernameQuery = "SELECT username FROM user_information WHERE email = :email";
    const getAccountPlanQuery = "SELECT plan FROM user_information WHERE email = :email";

    final params = {'email': email};

    final results = await Future.wait([
      conn.execute(getUsernameQuery, params),
      conn.execute(getAccountPlanQuery, params),
    ]);

    return results
      .expand((result) => result.rows.map((row) => row.assoc().values.first))
      .toList();

  }

  Future<String> getAccountAuthentication({
    required MySQLConnectionPool conn,
    required String? username
  }) async {

    const query = "SELECT password FROM user_information WHERE username = :username";
    final params = {'username': username};

    final results = await conn.execute(query, params);

    return results.rows.last.assoc()['password']!;

  }
  
}