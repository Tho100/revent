import 'package:get_it/get_it.dart';
import 'package:revent/connection/revent_connect.dart';
import 'package:revent/model/extract_data.dart';
import 'package:revent/provider/user_data_provider.dart';

class UserFollowing {

  final userData = GetIt.instance<UserDataProvider>();

  Future<bool> isFollowing({required String username}) async {

    try {

      final conn = await ReventConnect.initializeConnection();

      const query = 'SELECT follower FROM user_follows_info WHERE following = :following';
      final param = {
        'following': username
      };

      final results = await conn.execute(query, param);

      final rowsData = ExtractData(rowsData: results).extractStringColumn('follower');

      if(rowsData.contains(userData.username)) {
        return true;
      }

      return false;

    } catch (err) {
      return false;
    }

  }

}