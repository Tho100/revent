import 'package:get_it/get_it.dart';
import 'package:revent/service/revent_connection_service.dart';
import 'package:revent/shared/provider/user_data_provider.dart';

class UserActions {

  final String username;

  UserActions({required this.username});

  final userData = GetIt.instance<UserDataProvider>();

  Future<void> userFollowAction({required bool follow}) async {
    
    final conn = await ReventConnection.connect();

    await conn.transactional((txn) async {

      final operationSymbol = follow ? '+' : '-'; 

      final updateFollowingValueQuery = 
        'UPDATE user_profile_info SET following = following $operationSymbol 1 WHERE username = :username';
        
      await txn.execute(updateFollowingValueQuery, {'username': userData.user.username});

      final updateFollowerValueQuery = 
        'UPDATE user_profile_info SET followers = followers $operationSymbol 1 WHERE username = :username';

      await txn.execute(updateFollowerValueQuery, {'username': username});

      final insertOrDeleteFollowerQuery = follow 
        ? 'INSERT INTO user_follows_info (follower, following) VALUES (:follower, :following)'
        : 'DELETE FROM user_follows_info WHERE following = :following AND follower = :follower';

      await txn.execute(insertOrDeleteFollowerQuery, {'follower': userData.user.username, 'following': username});

    });
    
  }

}