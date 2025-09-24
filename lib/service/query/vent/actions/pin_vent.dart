import 'package:revent/shared/api/api_client.dart';
import 'package:revent/shared/api/api_path.dart';
import 'package:revent/shared/provider_mixins.dart';
import 'package:revent/service/query/general/base_query_service.dart';

class PinVent extends BaseQueryService with UserProfileProviderService, ProfilePostsProviderService {

  final int postId;
  
  PinVent({required this.postId});

  Future<Map<String, dynamic>> pinPost() async {

    final response = await _callPinRequest();

    if (response['status_code'] == 200) {
      _updateIsPinnedList(true);
    }

    return response;

  }

  Future<Map<String, dynamic>> unpinPost() async {

    final response = await _callPinRequest();

    if (response['status_code'] == 200) {
      _updateIsPinnedList(false);
    }

    return response;

  }

  Future<Map<String, dynamic>> _callPinRequest() async {

    final response = await ApiClient.post(ApiPath.pinVent, {
      'pinned_by': userProvider.user.username,
      'post_id': postId
    });

    return {
      'status_code': response.statusCode
    };

  }

  void _updateIsPinnedList(bool isPin) {

    final postsData = profilePostsProvider.myProfile;

    if (isPin) {

      postsData.isPinned = List.generate(postsData.isPinned.length, 
        (index) => postsData.postIds[index] == postId
      );

    } else {

      postsData.isPinned = List.generate(postsData.isPinned.length, 
        (index) => false
      );

    }

    profilePostsProvider.reorderPosts();

  }

}