import 'package:revent/global/table_names.dart';
import 'package:revent/service/query/general/base_query_service.dart';

class UserAuthService extends BaseQueryService {

  Future<String> getAccountAuthentication({required String username}) async {

    const query = 'SELECT password ${TableNames.userInfo} WHERE username = :username';

    final param = {'username': username};

    final results = await executeQuery(query, param);

    return results.rows.last.assoc()['password']!;

  }

  Future<void> updateAccountAuth({
    required String username,
    required String newPasswordHash
  }) async {

    const query = 'UPDATE ${TableNames.userInfo} SET password = :new_password WHERE username = :username';
    
    final params = {
      'username': username,
      'new_password': newPasswordHash
    };

    await executeQuery(query, params);

  }

}