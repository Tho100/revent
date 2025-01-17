import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/main.dart';
import 'package:revent/service/query/general/base_query_service.dart';

class UserBlockGetter extends BaseQueryService {

  final String username;

  UserBlockGetter({required this.username});

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