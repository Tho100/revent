import 'dart:convert';

import 'package:revent/helper/extract_data.dart';
import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/main.dart';
import 'package:revent/service/query/general/base_query_service.dart';

class UserBlockGetter extends BaseQueryService {

  final String username;

  UserBlockGetter({required this.username});

  Future<Map<String, dynamic>> getBlockedAccounts() async {

    const query = 
      '''
        SELECT 
          upi.username, 
          upi.profile_picture
        FROM user_profile_info upi
        LEFT JOIN user_blocked_info ubi
          ON ubi.blocked_username = upi.username
        WHERE ubi.blocked_by = :blocked_by
      ''';

    final param = {'blocked_by': username};

    final results = await executeQuery(query, param);

    final extractedData = ExtractData(rowsData: results);

    final usernames = extractedData.extractStringColumn('username');

    final profilePic = extractedData
      .extractStringColumn('profile_picture')
      .map((pfp) => base64Decode(pfp))
      .toList();

    return {
      'username': usernames,
      'profile_pic': profilePic
    };

  }

  Future<bool> getIsAccountBlocked() async {

    const query = 
    '''
      SELECT 1 
      FROM user_blocked_info 
      WHERE 
        (blocked_by = :blocked_by AND blocked_username = :blocked_username)
        OR
        (blocked_by = :blocked_username AND blocked_username = :blocked_by);
    ''';

    final params = {
      'blocked_username': username,
      'blocked_by': getIt.userProvider.user.username
    };

    final results = await executeQuery(query, params);

    return results.rows.isNotEmpty;

  }

}