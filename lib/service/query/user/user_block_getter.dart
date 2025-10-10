import 'package:revent/global/table_names.dart';
import 'package:revent/helper/extract_data.dart';
import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/helper/data_converter.dart';
import 'package:revent/main.dart';
import 'package:revent/service/query/general/base_query_service.dart';
import 'package:revent/shared/api/api_client.dart';
import 'package:revent/shared/api/api_path.dart';

class UserBlockGetter extends BaseQueryService {

  final String username;

  UserBlockGetter({required this.username});

  Future<Map<String, dynamic>> getBlockedAccounts() async {

    final response = await ApiClient.get(ApiPath.userBlockedAccountsGetter, username);

    final blockedAccounts = ExtractData(data: response.body!['blocked_accounts']);

    final usernames = blockedAccounts.extractColumn<String>('username');

    final profilePictures = DataConverter.convertToPfp(
      blockedAccounts.extractColumn<String>('profile_picture')
    );
    
    return {
      'username': usernames,
      'profile_pic': profilePictures
    };

  }

  Future<bool> getIsAccountBlocked() async {

    const query = 
    '''
      SELECT 1 
      FROM ${TableNames.userBlockedInfo} 
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