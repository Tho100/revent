import 'dart:convert';

import 'package:revent/service/query/general/base_query_service.dart';
import 'package:revent/helper/extract_data.dart';

class SearchAccountsGetter extends BaseQueryService {

  Future<Map<String, List<dynamic>>> getAccounts({required String searchText}) async {

    const query = 'SELECT username, profile_picture FROM user_profile_info WHERE username LIKE :search_text';

    final param = {'search_text': '%$searchText%'};

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