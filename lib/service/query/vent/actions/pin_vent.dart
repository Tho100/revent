import 'package:revent/shared/api/api_client.dart';
import 'package:revent/shared/api/api_path.dart';
import 'package:revent/shared/provider_mixins.dart';
import 'package:revent/service/query/general/base_query_service.dart';

class PinVent extends BaseQueryService with UserProfileProviderService, ProfilePostsProviderService {

  final int postId;
  
  PinVent({required this.postId});

  Future<Map<String, dynamic>> togglePinPost() async {

    final response = await ApiClient.post(ApiPath.pinVent, {
      'pinned_by': userProvider.user.username,
      'post_id': postId
    });

    if (response.statusCode == 200) {
      _updateIsPinnedList(response.body!['pinned']);
    }

    return {
      'status_code': response.statusCode
    };

  }

  void _updateIsPinnedList(bool pinned) {

    final postsData = profilePostsProvider.myProfile;

    if (pinned) {

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