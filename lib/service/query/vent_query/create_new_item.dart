import 'package:get_it/get_it.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:revent/service/revent_connection_service.dart';
import 'package:revent/helper/format_date.dart';
import 'package:revent/shared/provider/profile/profile_data_provider.dart';
import 'package:revent/shared/provider/user_data_provider.dart';
import 'package:revent/shared/provider/vent/vent_for_you_provider.dart';

class CreateNewItem {

  final ventData = GetIt.instance<VentForYouProvider>();
  final userData = GetIt.instance<UserDataProvider>();
  final profileData = GetIt.instance<ProfileDataProvider>();

  Future<void> newVent({
    required String ventTitle,
    required String ventBodyText,
  }) async {

    final conn = await ReventConnection.connect();

    await _insertVentInfo(
      conn: conn, 
      ventTitle: ventTitle, 
      ventBodyText: ventBodyText
    );

    await _updateTotalPosts(conn: conn);
    
    _addVent(
      ventTitle: ventTitle, 
      ventBodyText: ventBodyText
    );

  }

  Future<void> _insertVentInfo({
    required MySQLConnectionPool conn,
    required String ventTitle,
    required String ventBodyText
  }) async {

    const insertVentInfoQuery = 'INSERT INTO vent_info (creator, title, body_text, total_likes, total_comments) VALUES (:creator, :title, :body_text, :total_likes, :total_comments)';

    final params = {
      'creator': userData.user.username,
      'title': ventTitle,
      'body_text': ventBodyText,
      'total_likes': 0,
      'total_comments': 0,
    };

    await conn.execute(insertVentInfoQuery, params);

  }

  Future<void> _updateTotalPosts({
    required MySQLConnectionPool conn,
  }) async {

    const updateTotalPostsQuery = 
      'UPDATE user_profile_info SET posts = posts + 1 WHERE username = :username';

    final param = {
      'username': userData.user.username
    };

    await conn.execute(updateTotalPostsQuery, param);

  }

  void _addVent({
    required String ventTitle, 
    required String ventBodyText
  }) {

    final now = DateTime.now();
    final formattedTimestamp = FormatDate().formatPostTimestamp(now);

    final newVent = VentForYouData(
      title: ventTitle, 
      bodyText: ventBodyText, 
      creator: userData.user.username, 
      postTimestamp: formattedTimestamp, 
      profilePic: profileData.profilePicture
    );
    
    ventData.addVent(newVent);

  }

  Future<void> newArchiveVent({
    required String ventTitle,
    required String ventBodyText,
  }) async {

    final conn = await ReventConnection.connect();

    const insertVentInfoQuery = 'INSERT INTO archive_vent_info (creator, title, body_text) VALUES (:creator, :title, :body_text)';

    final params = {
      'creator': userData.user.username,
      'title': ventTitle,
      'body_text': ventBodyText,
    };

    await conn.execute(insertVentInfoQuery, params);

  }

}