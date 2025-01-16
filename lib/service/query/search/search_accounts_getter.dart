import 'dart:convert';

import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/main.dart';
import 'package:revent/service/query/general/base_query_service.dart';
import 'package:revent/helper/extract_data.dart';

class SearchAccountsGetter extends BaseQueryService {

  Future<Map<String, List<dynamic>>> getAccounts({required String searchText}) async {

    const query = 
    '''
      SELECT username, profile_picture 
      FROM user_profile_info upi
      LEFT JOIN user_blocked_info ubi
        ON upi.username = ubi.blocked_username AND ubi.blocked_by = :blocked_by
      WHERE upi.username LIKE :search_text AND ubi.blocked_username IS NULL
    ''';

    final param = {
      'search_text': '%$searchText%',
      'blocked_by': getIt.userProvider.user.username
    };

    final results = await executeQuery(query, param);

    final extractedData = ExtractData(rowsData: results);

    final usernames = extractedData.extractStringColumn('username');

    final profilePictures = extractedData
      .extractStringColumn('profile_picture')
      .map((pfp) => base64Decode(pfp))
      .toList();

    return {
      'username': usernames,
      'profile_pic': profilePictures,
    };

  }


}