import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/main.dart';
import 'package:revent/shared/api/api_client.dart';
import 'package:revent/shared/api/api_path.dart';

class UserFollowingStatus {

  static Future<bool> isFollowing({required String username}) async {

    final response = await ApiClient.post(ApiPath.userFollowingStatusGetter, {
      'following': username,
      'current_user': getIt.userProvider.user.username
    });

    return response.body!['is_following'];

  }

}