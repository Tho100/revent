import 'package:get_it/get_it.dart';
import 'package:revent/connection/revent_connect.dart';
import 'package:revent/provider/user_data_provider.dart';

class UserFollowing {

  final userData = GetIt.instance<UserDataProvider>();

  Future<bool> isFollowing({required String username}) async {

    try {

      final conn = await ReventConnect.initializeConnection();

      const query = 'SELECT 1 FROM user_follows_info WHERE following = :following AND follower = :follower LIMIT 1';
      final param = {
        'following': username,
        'follower': userData.username
      };

      final results = await conn.execute(query, param);

      return results.rows.isNotEmpty;

    } catch (err) {
      return false;
    }

  }

}