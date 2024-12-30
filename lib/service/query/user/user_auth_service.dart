import 'package:mysql_client/mysql_client.dart';
import 'package:revent/service/query/general/base_query_service.dart';

class UserAuthService extends BaseQueryService {

  Future<String> getAccountAuthentication({
    required MySQLConnectionPool conn,
    required String username
  }) async {

    const query = 'SELECT password FROM user_information WHERE username = :username';
    final params = {'username': username};

    final results = await executeQuery(query, params);

    return results.rows.last.assoc()['password']!;

  }

  Future<void> updateAccountAuth({
    required MySQLConnectionPool conn,
    required String username,
    required String newPasswordHash
  }) async {

    const query = 'UPDATE user_information SET password = :new_password WHERE username = :username';
    
    final params = {
      'username': username,
      'new_password': newPasswordHash
    };

    await executeQuery(query, params);

  }

}