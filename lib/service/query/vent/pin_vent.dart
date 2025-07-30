import 'package:revent/global/table_names.dart';
import 'package:revent/shared/provider_mixins.dart';
import 'package:revent/service/query/general/base_query_service.dart';
import 'package:revent/service/query/general/post_id_getter.dart';

class PinVent extends BaseQueryService with UserProfileProviderService, ProfilePostsProviderService {

  final String title;
  
  PinVent({required this.title});

  Future<void> pin() async {

    final postId = await PostIdGetter(title: title, creator: userProvider.user.username).getPostId();

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

    final postId = await PostIdGetter(title: title, creator: userProvider.user.username).getPostId();

    const query = 'DELETE ${TableNames.pinnedVentInfo} WHERE post_id = :post_id AND pinned_by = :pinned_by';

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
        (index) => postsData.titles[index] == title
      );

    } else {

      postsData.isPinned = List.generate(postsData.isPinned.length, 
        (index) => false
      );

    }

    profilePostsProvider.reorderPosts();

  }

}