import 'package:revent/global/table_names.dart';
import 'package:revent/shared/api/api_client.dart';
import 'package:revent/shared/api/api_path.dart';
import 'package:revent/shared/provider_mixins.dart';
import 'package:revent/service/query/general/base_query_service.dart';

class PinVent extends BaseQueryService with UserProfileProviderService, ProfilePostsProviderService {

  final int postId;
  
  PinVent({required this.postId});

  Future<Map<String, dynamic>> pin() async {

    final response = await ApiClient.post(ApiPath.pinVent, {
      'pinned_by': userProvider.user.username,
      'post_id': postId
    });

    if (response.statusCode == 201) {
      _updateIsPinnedList(true);
    }

    return {
      'status_code': response.statusCode
    };

  }

  Future<void> unpin() async {

    const query = 'DELETE FROM ${TableNames.pinnedVentInfo} WHERE post_id = :post_id AND pinned_by = :pinned_by';

    final params = {
      'pinned_by': userProvider.user.username,
      'post_id': postId
    };

    await executeQuery(query, params).then(
      (_) => _updateIsPinnedList(false)
    );

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