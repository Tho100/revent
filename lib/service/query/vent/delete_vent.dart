import 'package:revent/global/table_names.dart';
import 'package:revent/shared/provider_mixins.dart';
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

    final conn = await connection();

    await conn.transactional((txn) async {
      
      await txn.execute(
        '''
          DELETE vi, lvi, svi
          ${TableNames.ventInfo} vi
            LEFT JOIN liked_vent_info lvi ON lvi.post_id = vi.post_id
            LEFT JOIN saved_vent_info svi ON svi.post_id = vi.post_id
          WHERE vi.post_id = :post_id
        ''',
        {'post_id': postId}
      );

      await txn.execute(
        '''
          DELETE comments_likes_info
            ${TableNames.commentsLikesInfo}
          INNER JOIN comments_info
            ON comments_likes_info.comment_id = comments_info.comment_id
          WHERE comments_info.post_id = :post_id
        ''',
        {'post_id': postId}
      );

      await txn.execute(
        'DELETE ${TableNames.commentsInfo} WHERE post_id = :post_id',
        {'post_id': postId}
      );

      await txn.execute(
        'UPDATE user_profile_info SET posts = posts - 1 WHERE username = :username',
        {'username': userProvider.user.username}
      );

    }).then(
      (_) => _removeVent()
    );

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