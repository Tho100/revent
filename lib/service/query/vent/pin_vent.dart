import 'package:revent/global/table_names.dart';
import 'package:revent/shared/provider_mixins.dart';
import 'package:revent/service/query/general/base_query_service.dart';

class PinVent extends BaseQueryService with UserProfileProviderService, ProfilePostsProviderService {

  final int postId;
  
  PinVent({required this.postId});

  Future<void> pin() async {

    const query = 'INSERT INTO ${TableNames.pinnedVentInfo} (pinned_by, post_id) VALUES (:pinned_by, :post_id)';

    final params = {
      'pinned_by': userProvider.user.username,
      'post_id': postId
    };

    await executeQuery(query, params).then(
      (_) => _updateIsPinnedList(true)
    );

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