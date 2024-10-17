import 'package:revent/connection/revent_connect.dart';

class UserActions {

  final String username;

  UserActions({required this.username});

  Future<bool> userFollowAction({required bool follow}) async {
    
    try {

      final conn = await ReventConnect.initializeConnection();

      final query = follow 
        ? "UPDATE user_profile_info SET followers = followers + 1 WHERE username = :username"
        : "UPDATE user_profile_info SET followers = followers - 1 WHERE username = :username";
        
      final param = {
        'username': username
      };

      await conn.execute(query, param);

      return true;

    } catch (err) {
      return false;
    }
    
  }

}