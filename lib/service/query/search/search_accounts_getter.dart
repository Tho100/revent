import 'package:revent/global/table_names.dart';
import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/helper/data_converter.dart';
import 'package:revent/main.dart';
import 'package:revent/service/query/general/base_query_service.dart';
import 'package:revent/helper/extract_data.dart';

class SearchAccountsGetter extends BaseQueryService {

  Future<Map<String, List<dynamic>>> getAccounts({required String searchText}) async {

    const query = 
    '''
      SELECT username, profile_picture 
      FROM ${TableNames.userProfileInfo} upi
      WHERE upi.username LIKE :search_text
        AND NOT EXISTS (
          SELECT 1
          FROM ${TableNames.userBlockedInfo} ubi
          WHERE ubi.blocked_by = :blocked_by
            AND ubi.blocked_username = upi.username
        )
    ''';

    final param = {
      'search_text': '%$searchText%',
      'blocked_by': getIt.userProvider.user.username
    };

    final results = await executeQuery(query, param);

    final extractedData = ExtractData(rowsData: results);

    final usernames = extractedData.extractStringColumn('username');

    final profilePictures = DataConverter.convertToPfp(
      extractedData.extractStringColumn('profile_picture')
    );
    
    return {
      'username': usernames,
      'profile_pic': profilePictures,
    };

  }


}