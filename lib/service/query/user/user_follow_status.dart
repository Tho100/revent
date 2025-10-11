import 'package:revent/global/table_names.dart';
import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/main.dart';
import 'package:revent/service/query/general/base_query_service.dart';

class UserFollowStatus extends BaseQueryService {
// TODO: make request to backend
  Future<bool> isFollowing({required String username}) async {

    const query = 
      'SELECT 1 FROM ${TableNames.userFollowsInfo} WHERE following = :following AND follower = :follower LIMIT 1';
      
    final param = {
      'following': username,
      'follower': getIt.userProvider.user.username
    };

    final results = await executeQuery(query, param);

    return results.rows.isNotEmpty;

  }

}