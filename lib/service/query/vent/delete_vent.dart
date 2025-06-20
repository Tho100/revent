import 'package:revent/helper/providers_service.dart';
import 'package:revent/service/query/general/base_query_service.dart';
import 'package:revent/service/current_provider_service.dart';
import 'package:revent/service/query/general/post_id_getter.dart';

class DeleteVent extends BaseQueryService with UserProfileProviderService, VentProviderService {

  final String title;

  DeleteVent({required this.title});

  Future<void> delete() async {

    final postId = activeVentProvider.ventData.postId != 0 
      ? activeVentProvider.ventData.postId 
      : await PostIdGetter(title: title, creator: userProvider.user.username).getPostId();

    await _deleteVentInfo(postId: postId)
      .then((_) => _deleteComments(postId: postId))
      .then((_) => _updateTotalPosts());

    _removeVent();

  }

  Future<void> _deleteVentInfo({required int postId}) async {

    const query =
    '''
      DELETE vi, lvi, svi
      FROM vent_info vi
        LEFT JOIN liked_vent_info lvi ON lvi.post_id = vi.post_id
        LEFT JOIN saved_vent_info svi ON svi.post_id = vi.post_id
      WHERE vi.post_id = :post_id
    ''';

    final param = {'post_id': postId};

    await executeQuery(query, param);

  }
 
  Future<void> _updateTotalPosts() async {

    const updateTotalPostsQuery = 
      'UPDATE user_profile_info SET posts = posts - 1 WHERE username = :username';

    final param = {'username': userProvider.user.username};

    await executeQuery(updateTotalPostsQuery, param);

  }

  Future<void> _deleteComments({required int postId}) async {

    final queries = [
      '''
        DELETE comments_likes_info
          FROM comments_likes_info
        INNER JOIN comments_info
          ON comments_likes_info.comment_id = comments_info.comment_id
        WHERE comments_info.post_id = post_id
      ''',
      'DELETE FROM comments_info WHERE post_id = :post_id'
    ];

    final param = {'post_id': postId};

    final conn = await connection();

    await conn.transactional((txn) async {
      for(int i=0; i<queries.length; i++) {
        await txn.execute(queries[i], param);
      }
    });

  }

  void _removeVent() {

    final currentProvider = CurrentProviderService(
      title: title, 
      creator: userProvider.user.username
    ).getProvider();

    final ventIndex = currentProvider['vent_index'];    
    final ventData = currentProvider['vent_data'];    

    if (ventIndex != -1) {
      ventData.deleteVent(ventIndex);
    }

  }

}