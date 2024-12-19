import 'package:get_it/get_it.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:revent/service/revent_connection_service.dart';
import 'package:revent/helper/current_provider.dart';
import 'package:revent/shared/provider/user_data_provider.dart';

class DeleteVent {
  
  final String title;
  final String creator;

  DeleteVent({
    required this.title,
    required this.creator,
  });
  // TODO: Use getIt and BaseQueryService
  final userData = GetIt.instance<UserDataProvider>();

  Future<void> delete() async {

    final conn = await ReventConnection.connect();

    await _deleteVentInfo(
      conn: conn, 
      ventTitle: title
    );

    await _updateTotalPosts(conn: conn);

    await _deleteComments(
      conn: conn, 
      title: title, 
    );

    _removeVent();

  }

  Future<void> _deleteVentInfo({
    required MySQLConnectionPool conn,
    required String ventTitle
  }) async {

    const query = 'DELETE FROM vent_info WHERE title = :title AND creator = :creator';
    final params = {
      'title': ventTitle,
      'creator': userData.user.username,
    };

    await conn.execute(query, params);

  }
 
  Future<void> _updateTotalPosts({
    required MySQLConnectionPool conn,
  }) async {

    const updateTotalPostsQuery = 
      'UPDATE user_profile_info SET posts = posts - 1 WHERE username = :username';

    final param = {
      'username': userData.user.username
    };

    await conn.execute(updateTotalPostsQuery, param);

  }

  Future<void> _deleteComments({
    required MySQLConnectionPool conn,
    required String title,
  }) async {

    final params = {
      'title': title,
      'creator': userData.user.username,
    };

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

    final currentProvider = CurrentProvider(
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