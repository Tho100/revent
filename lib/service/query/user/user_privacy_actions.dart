import 'package:revent/global/table_names.dart';
import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/main.dart';
import 'package:revent/service/query/general/base_query_service.dart';
import 'package:revent/helper/extract_data.dart';

class UserPrivacyActions extends BaseQueryService {

  Future<void> updatePrivacyOption({
    required int value, 
    required String column
  }) async {

    final query = 'UPDATE ${TableNames.userPrivacyInfo} SET $column = :new_value WHERE username = :username';

    final param = {
      'username': getIt.userProvider.user.username,
      'new_value': value
    };

    await executeQuery(query, param);

  }

  Future<Map<String, int>> getCurrentPrivacyOptions({required String username}) async {

    const query = 
    '''
      SELECT privated_profile, privated_following_list, privated_saved_vents 
      FROM ${TableNames.userPrivacyInfo} 
      WHERE username = :username
    ''';

    final param = {'username': username};

    final results = await executeQuery(query, param);

    final extractedData = ExtractData(rowsData: results);

    final privatedAccount = extractedData.extractIntColumn('privated_profile')[0];
    final privatedFollowing = extractedData.extractIntColumn('privated_following_list')[0];
    final privatedSaved = extractedData.extractIntColumn('privated_saved_vents')[0];

    return {
      'account': privatedAccount,
      'following': privatedFollowing,
      'saved': privatedSaved,
    };

  }

}