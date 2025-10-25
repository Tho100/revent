import 'package:revent/global/table_names.dart';
import 'package:revent/shared/api/api_client.dart';
import 'package:revent/shared/api/api_path.dart';
import 'package:revent/shared/provider_mixins.dart';
import 'package:revent/service/query/general/base_query_service.dart';

class UserActions extends BaseQueryService with UserProfileProviderService {

  final String username;

  UserActions({required this.username});

  Future<Map<String, dynamic>> toggleFollowUser() async {
    
    final response = await ApiClient.post(ApiPath.followUser, {
      'current_user': userProvider.user.username,
      'following': username,
    });

    return {
      'status_code': response.statusCode
    };

  }

  Future<void> toggleBlockUser({bool? block = true}) async {

    final query = block!
      ? 'INSERT INTO ${TableNames.userBlockedInfo} (blocked_username, blocked_by) VALUES (:blocked_username, :blocked_by)'
      : 'DELETE FROM ${TableNames.userBlockedInfo} WHERE blocked_by = :blocked_by AND blocked_username = :blocked_username';

    final params = {
      'blocked_username': username,
      'blocked_by': userProvider.user.username
    };

    await executeQuery(query, params);

  }

}