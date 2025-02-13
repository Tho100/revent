import 'dart:convert';

import 'package:revent/helper/extract_data.dart';
import 'package:revent/helper/providers_service.dart';
import 'package:revent/service/query/general/base_query_service.dart';

class FollowSuggestionGetter extends BaseQueryService with UserProfileProviderService {

  Future<Map<String, dynamic>> getSuggestion() async {

    const query = 
    '''
    (
      SELECT DISTINCT uf2.following
      FROM user_follows_info uf1
      JOIN user_follows_info uf2 
          ON uf1.following = uf2.follower
      WHERE uf1.follower = :username
        AND uf2.following NOT IN (
          SELECT following FROM user_follows_info WHERE follower = :username
          )
          AND uf2.following != :username
    ) 
      UNION
    (
      SELECT username 
      FROM user_profile_info 
        WHERE username != :username
          GROUP BY username
          ORDER BY COUNT(followers)
    ) 
      LIMIT 5
    ''';

    final param = {'username': userProvider.user.username};

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