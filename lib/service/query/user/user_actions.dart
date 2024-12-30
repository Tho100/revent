import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/main.dart';
import 'package:revent/service/query/general/base_query_service.dart';

class UserActions extends BaseQueryService {

  final String username;

  UserActions({required this.username});

  final userData = getIt.userProvider;

  Future<void> userFollowAction({required bool follow}) async {
    
    final operationSymbol = follow ? '+' : '-'; 

    final queries = [
      'UPDATE user_profile_info SET following = following $operationSymbol 1 WHERE username = :username',
      'UPDATE user_profile_info SET followers = followers $operationSymbol 1 WHERE username = :username',
      follow 
        ? 'INSERT INTO user_follows_info (follower, following) VALUES (:follower, :following)'
        : 'DELETE FROM user_follows_info WHERE following = :following AND follower = :follower'
    ];

    final params = [
      {'username': userData.user.username},
      {'username': username},
      {'follower': userData.user.username, 'following': username}
    ];

    final conn = await connection();

    await conn.transactional((txn) async {
      for(int i=0; i<queries.length; i++) {
        await txn.execute(queries[i], params[i]);
      }
    });
    
  }

}