import 'package:revent/shared/provider_mixins.dart';
import 'package:revent/service/query/general/base_query_service.dart';

class UserActions extends BaseQueryService with UserProfileProviderService {

  final String username;

  UserActions({required this.username});

  Future<void> toggleFollowUser({required bool follow}) async {
    
    final operationSymbol = follow ? '+' : '-'; 

    final conn = await connection();

    await conn.transactional((txn) async {
      
      await txn.execute(
        'UPDATE user_profile_info SET following = following $operationSymbol 1 WHERE username = :username',
        {'username': userProvider.user.username}
      );
      
      await txn.execute(
        'UPDATE user_profile_info SET followers = followers $operationSymbol 1 WHERE username = :username',
        {'username': username}
      );

      await txn.execute(
        follow 
          ? 'INSERT INTO user_follows_info (follower, following) VALUES (:follower, :following)'
          : 'DELETE FROM user_follows_info WHERE following = :following AND follower = :follower',
        {
          'follower': userProvider.user.username, 
          'following': username
        }
      );

    });
    
  }

  Future<void> blockUser({bool? block = true}) async {

    final query = block!
      ? 'INSERT INTO user_blocked_info (blocked_username, blocked_by) VALUES (:blocked_username, :blocked_by)'
      : 'DELETE FROM user_blocked_info WHERE blocked_by = :blocked_by AND blocked_username = :blocked_username';

    final params = {
      'blocked_username': username,
      'blocked_by': userProvider.user.username
    };

    await executeQuery(query, params);

  }

}