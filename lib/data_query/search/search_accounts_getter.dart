import 'dart:convert';

import 'package:revent/service/revent_connection_service.dart';
import 'package:revent/model/extract_data.dart';

class SearchAccountsGetter {

  Future<Map<String, List<dynamic>>> getAccounts({required String searchText}) async {

    final conn = await ReventConnection.connect();

    const query = 'SELECT username, profile_picture FROM user_profile_info WHERE username LIKE :search_text';

    final param = {'search_text': '%$searchText%'};

    final results = await conn.execute(query, param);

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