import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/main.dart';
import 'package:revent/service/query/general/base_query_service.dart';
import 'package:revent/service/current_provider_service.dart';

class DeleteVent extends BaseQueryService {
  
  final String title;
  final String creator;

  DeleteVent({
    required this.title,
    required this.creator,
  });

  final userData = getIt.userProvider;

  Future<void> delete() async {

    await _deleteVentInfo(ventTitle: title).then((_) async {
      await _updateTotalPosts();
      await _deleteComments(title: title);
    });

    _removeVent();

  }

  Future<void> _deleteVentInfo({required String ventTitle}) async {

    const query = 'DELETE FROM vent_info WHERE title = :title AND creator = :creator';

    final params = {
      'title': ventTitle,
      'creator': userData.user.username,
    };

    await executeQuery(query, params);

  }
 
  Future<void> _updateTotalPosts() async {

    const updateTotalPostsQuery = 
      'UPDATE user_profile_info SET posts = posts - 1 WHERE username = :username';

    final param = {
      'username': userData.user.username
    };

    await executeQuery(updateTotalPostsQuery, param);

  }

  Future<void> _deleteComments({required String title}) async {

    final params = {
      'title': title,
      'creator': userData.user.username,
    };

    final conn = await connection();

    await conn.transactional((txn) async {

      const deleteCommentsQuery = 
        'DELETE FROM vent_comments_info WHERE title = :title AND creator = :creator'; 
        
      await txn.execute(deleteCommentsQuery, params);

      const deleteCommentsLikesInfoQuery = 
        'DELETE FROM vent_comments_likes_info WHERE title = :title AND creator = :creator'; 

      await txn.execute(deleteCommentsLikesInfoQuery, params);

    });

  }

  void _removeVent() {

    final currentProvider = CurrentProviderService(
      title: title, 
      creator: creator
    ).getProvider();

    final ventIndex = currentProvider['vent_index'];    
    final ventData = currentProvider['vent_data'];    

    if(ventIndex != -1) {
      ventData.deleteVent(ventIndex);
    }

  }

}