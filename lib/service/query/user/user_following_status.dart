import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/main.dart';
import 'package:revent/service/query/general/base_query_service.dart';
import 'package:revent/shared/api/api_client.dart';
import 'package:revent/shared/api/api_path.dart';
// TODO: rename to UserFollowingStatus
class UserFollowingStatus extends BaseQueryService { // And remove this
// TODO: make class static
  Future<bool> isFollowing({required String username}) async {

    final response = await ApiClient.post(ApiPath.userFollowingStatusGetter, {
      'following': username,
      'current_user': getIt.userProvider.user.username
    });

    return response.body!['is_following'];

  }

}