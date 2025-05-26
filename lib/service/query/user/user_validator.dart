import 'package:revent/service/query/general/base_query_service.dart';

class UserValidator extends BaseQueryService {

  Future<bool> userExists({required String username}) async {

    const query = 'SELECT 1 FROM user_information WHERE username = :username';

    final param = {'username': username};

    final results = await executeQuery(query, param);

    return results.rows.isNotEmpty;

  }

}