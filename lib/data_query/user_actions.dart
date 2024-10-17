import 'package:get_it/get_it.dart';
import 'package:revent/connection/revent_connect.dart';
import 'package:revent/provider/user_data_provider.dart';

class UserActions {

  final String username;

  UserActions({required this.username});

  final userData = GetIt.instance<UserDataProvider>();

  Future<void> userFollowAction({required bool follow}) async {
    
    try {

      final conn = await ReventConnect.initializeConnection();

      final updateFollowingValueQuery = follow 
        ? 'UPDATE user_profile_info SET following = following + 1 WHERE username = :username'
        : 'UPDATE user_profile_info SET following = following - 1 WHERE username = :username';

      final updateFollowerValueQuery = follow 
        ? 'UPDATE user_profile_info SET followers = followers + 1 WHERE username = :username'
        : 'UPDATE user_profile_info SET followers = followers - 1 WHERE username = :username';

      final insertOrDeleteFollowerQuery = follow 
        ? 'INSERT INTO user_follows_info (follower, following) VALUES (:follower, :following)'
        : 'DELETE FROM user_follows_info WHERE following = :following AND follower = :follower';


      final queries = [
        updateFollowingValueQuery,
        updateFollowerValueQuery,
        insertOrDeleteFollowerQuery
      ];

      final params = [
        {
          'username': userData.username
        },
        {
          'username': username
        },
        { 
          'follower': userData.username,
          'following': username
        }
      ];

      for (int i=0; i<queries.length; i++) {
        await conn.execute(queries[i], params[i]);
      }

    } catch (err) {
      print(err.toString());
    }
    
  }

}