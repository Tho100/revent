import 'package:revent/helper/extract_data.dart';
import 'package:revent/service/query/general/base_query_service.dart';

class UserDataGetter extends BaseQueryService {

  Future<String?> getUsername({required String email}) async {

    const query = 'SELECT username FROM user_information WHERE email = :email';

    final param = {'email': email};
    
    final results = await executeQuery(query, param);

    if(results.rows.isEmpty) {
      return null;
    }

    return ExtractData(rowsData: results).extractStringColumn('username')[0];

  }

  Future<String> getJoinedDate({required String username}) async {

    const query = 'SELECT created_at FROM user_information WHERE username = :username';

    final param = {'username': username};
    
    final results = await executeQuery(query, param);

    return ExtractData(rowsData: results).extractStringColumn('created_at')[0];

  }
  // TODO: Remove Plan, and rename this functio to getEmail
  Future<Map<String, dynamic>> getUserStartupInfo({required String email}) async {

    const query = 'SELECT username, plan FROM user_information WHERE email = :email';

    final param = {'email': email};
    
    final results = await executeQuery(query, param);

    final extractedData = ExtractData(rowsData: results);

    final username = extractedData.extractStringColumn('username')[0];
    final plan = extractedData.extractStringColumn('plan')[0];

    return {
      'username': username,
      'plan': plan,
    };

  }

}