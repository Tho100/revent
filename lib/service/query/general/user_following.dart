import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/main.dart';
import 'package:revent/service/query/general/base_query_service.dart';

class UserFollowing extends BaseQueryService {

  final userData = getIt.userProvider;

  Future<bool> isFollowing({required String username}) async {

    const query = 
      'SELECT 1 FROM user_follows_info WHERE following = :following AND follower = :follower LIMIT 1';
      
    final param = {
      'following': username,
      'follower': userData.user.username
    };

    final results = await executeQuery(query, param);

    return results.rows.isNotEmpty;

  }

}