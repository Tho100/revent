import 'package:get_it/get_it.dart';
import 'package:revent/service/revent_connection_service.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/model/local_storage_model.dart';
import 'package:revent/provider/profile/profile_data_provider.dart';
import 'package:revent/provider/profile/profile_posts_provider.dart';
import 'package:revent/provider/user_data_provider.dart';

class UserModel {

  void signOutUser() async {

    GetIt.instance<UserDataProvider>().clearUserData();
    GetIt.instance<ProfileDataProvider>().clearProfileData();
    GetIt.instance<ProfilePostsProvider>().clearPostsData();

    await LocalStorageModel().deleteLocalData();

    NavigatePage.mainScreenPage();

  }

  Future<void> deleteAccountData({required String username}) async {

    final conn = await ReventConnection.connect();

    const query = '''
      DELETE ui, upi, ufi, vi, svi, avi, lvi, vci, vcli
      FROM user_information ui
      LEFT JOIN user_profile_info upi ON upi.username = ui.username
      LEFT JOIN user_follows_info ufi ON ufi.follower = ui.username
      LEFT JOIN vent_info vi ON vi.creator = ui.username
      LEFT JOIN saved_vent_info svi ON svi.creator = ui.username
      LEFT JOIN archive_vent_info avi ON avi.creator = ui.username
      LEFT JOIN liked_vent_info lvi ON lvi.liked_by = ui.username
      LEFT JOIN vent_comments_info vci ON vci.commented_by = ui.username
      LEFT JOIN vent_comments_likes_info vcli ON vcli.liked_by = ui.username
      WHERE ui.username = :username;
    ''';

    final param = {'username': username};

    await conn.execute(query, param);

  }

}