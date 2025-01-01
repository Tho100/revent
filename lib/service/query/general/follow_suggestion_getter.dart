import 'dart:convert';

import 'package:revent/helper/extract_data.dart';
import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/main.dart';
import 'package:revent/service/query/general/base_query_service.dart';

class FollowSuggestionGetter extends BaseQueryService {

  Future<Map<String, dynamic>> getSuggestion() async {

    const query = 
    '''
      SELECT username, profile_picture
        FROM user_profile_info
        WHERE username != :username AND username NOT IN (
          SELECT following
          FROM user_follows_info
          WHERE follower = :username
        )
        LIMIT 5;
    ''';

    final param = {'username': getIt.userProvider.user.username};

    final results = await executeQuery(query, param);

    final extractedData = ExtractData(rowsData: results);

    final usernames = extractedData.extractStringColumn('username');
    
    final profilePic = extractedData.extractStringColumn('profile_picture')
      .map((pfp) => base64Decode(pfp))
      .toList();

    return {
      'usernames': usernames,
      'profile_pic': profilePic
    };

  }

}