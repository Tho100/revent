import 'package:get_it/get_it.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:revent/connection/revent_connect.dart';
import 'package:revent/provider/user_data_provider.dart';
import 'package:revent/provider/vent_data_provider.dart';

class DeleteVent {

  final ventData = GetIt.instance<VentDataProvider>();
  final userData = GetIt.instance<UserDataProvider>();

  Future<void> delete({required String ventTitle}) async {

    final conn = await ReventConnect.initializeConnection();

    await _deleteVentInfo(
      conn: conn, 
      ventTitle: ventTitle
    );

    await _updateTotalPosts(conn: conn);

    _removeVent(title: ventTitle);

  }

  Future<void> _deleteVentInfo({
    required MySQLConnectionPool conn,
    required String ventTitle
  }) async {

    const query = "DELETE FROM vent_info WHERE title = :title AND creator = :creator";
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

  void _removeVent({required String title}) {

    final index = ventData.vents.indexWhere((vent) => vent.title == title);

    if(index != -1) {
      ventData.deleteVent(index);
    }

  }

}