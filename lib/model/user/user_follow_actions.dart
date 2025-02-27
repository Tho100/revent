import 'package:revent/service/query/user/user_actions.dart';

class UserFollowActions {

  final String username;

  UserFollowActions({required this.username});

  Future<void> followUser({required bool follow}) async {
    follow 
      ? await UserActions(username: username).toggleFollowUser(follow: true)
      : await UserActions(username: username).toggleFollowUser(follow: false);
  }

}