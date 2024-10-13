import 'package:get_it/get_it.dart';
import 'package:revent/connection/revent_connect.dart';
import 'package:revent/model/format_post_timestamp.dart';
import 'package:revent/provider/profile_data_provider.dart';
import 'package:revent/provider/user_data_provider.dart';
import 'package:revent/provider/vent_data_provider.dart';

class CreateNewItem {

  final ventData = GetIt.instance<VentDataProvider>();
  final userData = GetIt.instance<UserDataProvider>();
  final profileData = GetIt.instance<ProfileDataProvider>();

  Future<void> newVent({
    required String ventTitle,
    required String ventBodyText,
  }) async {

    final conn = await ReventConnect.initializeConnection();

    const query = "INSERT INTO vent_info (creator, title, body_text, total_likes, total_comments) VALUES (:creator, :title, :body_text, :total_likes, :total_comments)";
    final params = {
      'creator': userData.username,
      'title': ventTitle,
      'body_text': ventBodyText,
      'total_likes': 0,
      'total_comments': 0,
    };

    await conn.execute(query, params);

    final now = DateTime.now();
    final formattedTimestamp = FormatPostTimestamp().formatTimeAgo(now);

    ventData.addVentData(
      ventTitle, ventBodyText, 
      userData.username, formattedTimestamp, profileData.profilePicture
    );

  }

  void newForum() {

  }

}