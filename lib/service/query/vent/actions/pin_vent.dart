import 'package:revent/shared/api/api_client.dart';
import 'package:revent/shared/api/api_path.dart';
import 'package:revent/shared/provider_mixins.dart';

class PinVent with UserProfileProviderService, ProfilePostsProviderService {

  final int postId;
  
  PinVent({required this.postId});

  Future<Map<String, dynamic>> togglePinPost() async {

    final response = await ApiClient.post(ApiPath.pinVent, {
      'pinned_by': userProvider.user.username,
      'post_id': postId
    });

    final index = profilePostsProvider.myProfile.postIds.indexWhere(
      (currentPostId) => currentPostId == postId
    );

    final isPinned = profilePostsProvider.myProfile.isPinned[index];

    if (response.statusCode == 200) {
      _updateIsPinnedList(!isPinned);
    }

    return {
      'status_code': response.statusCode
    };

  }

  void _updateIsPinnedList(bool doPin) {

    final postsData = profilePostsProvider.myProfile;

    if (doPin) {

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