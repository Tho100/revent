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

}