import 'package:get_it/get_it.dart';
import 'package:revent/service/query/general/base_query_service.dart';
import 'package:revent/shared/provider/user_data_provider.dart';

class UserFollowing extends BaseQueryService {

  final userData = GetIt.instance<UserDataProvider>();

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