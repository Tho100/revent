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

      await conn.transactional((conn) async {

        final operationSymbol = follow ? '+' : '-'; 

        final updateFollowingValueQuery = 
          'UPDATE user_profile_info SET following = following $operationSymbol 1 WHERE username = :username';
          
        await conn.execute(updateFollowingValueQuery, {'username': userData.username});

        final updateFollowerValueQuery = 
          'UPDATE user_profile_info SET followers = followers $operationSymbol 1 WHERE username = :username';

        await conn.execute(updateFollowerValueQuery, {'username': username});

        final insertOrDeleteFollowerQuery = follow 
          ? 'INSERT INTO user_follows_info (follower, following) VALUES (:follower, :following)'
          : 'DELETE FROM user_follows_info WHERE following = :following AND follower = :follower';

        await conn.execute(insertOrDeleteFollowerQuery, {'follower': userData.username, 'following': username});

      });

    } catch (err) {
      print(err.toString());
    }
    
  }

}