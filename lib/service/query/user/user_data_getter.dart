import 'package:revent/global/table_names.dart';
import 'package:revent/helper/extract_data.dart';
import 'package:revent/service/query/general/base_query_service.dart';

class UserDataGetter extends BaseQueryService {

  Future<String?> getUsername({required String email}) async {

    const query = 'SELECT username FROM ${TableNames.userInfo} WHERE email = :email';

    final param = {'email': email};
    
    final results = await executeQuery(query, param);

    if (results.rows.isEmpty) {
      return null;
    }

    return ExtractData(rowsData: results).extractStringColumn('username')[0];

  }

  Future<String> getJoinedDate({required String username}) async {

    const query = 'SELECT created_at FROM ${TableNames.userInfo} WHERE username = :username';

    final param = {'username': username};
    
    final results = await executeQuery(query, param);

    return ExtractData(rowsData: results).extractStringColumn('created_at')[0];

  }

  Future<String> getCountry({required String username}) async {

    const query = 'SELECT country FROM ${TableNames.userProfileInfo} WHERE username = :username';

    final param = {'username': username};
    
    final results = await executeQuery(query, param);

    return ExtractData(rowsData: results).extractStringColumn('country')[0];

  }

  Future<Map<String, String>> getSocialHandles({String? username}) async {

    const query = 'SELECT platform, social_handle FROM ${TableNames.userSocialLinks} WHERE username = :username';

    final param = {'username': username};
    
    final results = await executeQuery(query, param);

    if (results.isEmpty) {
      return {};
    }

    final extractedData = ExtractData(rowsData: results);

    final platforms = extractedData.extractStringColumn('platform');
    final handles = extractedData.extractStringColumn('social_handle');

    Map<String, String> socialHandles = {};
    
    for (int i = 0; i < platforms.length; i++) {
      if (handles[i].isNotEmpty) {
        socialHandles[platforms[i]] = handles[i];
      }
    }

    return socialHandles;

  }

}