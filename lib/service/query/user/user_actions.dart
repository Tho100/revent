import 'package:revent/shared/api/api_client.dart';
import 'package:revent/shared/api/api_path.dart';
import 'package:revent/shared/provider_mixins.dart';
import 'package:revent/service/query/general/base_query_service.dart';
// TODO: Remove basequeryservice
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

  Future<Map<String, dynamic>> toggleBlockUser() async {

    final response = await ApiClient.post(ApiPath.blockUser, {
      'current_user': userProvider.user.username,
      'block_user': username,
    });

    return {
      'status_code': response.statusCode
    };

  }

}