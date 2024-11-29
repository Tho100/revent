import 'package:get_it/get_it.dart';
import 'package:revent/connection/revent_connect.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/model/local_storage_model.dart';
import 'package:revent/provider/profile/profile_data_provider.dart';
import 'package:revent/provider/profile/profile_posts_provider.dart';
import 'package:revent/provider/user_data_provider.dart';

class UserModel {

  void signOutUser() async {

    final userData = GetIt.instance<UserDataProvider>();
    final profileData = GetIt.instance<ProfileDataProvider>();
    final profilePostsData = GetIt.instance<ProfilePostsProvider>();

    userData.clearUserData();
    profileData.clearProfileData();
    profilePostsData.clearPostsData();

    await LocalStorageModel().deleteLocalData();

    NavigatePage.mainScreenPage();

  }

  Future<void> deleteAccountData({required String username}) async {

    final conn = await ReventConnect.initializeConnection();

    const queries = [
      'DELETE FROM user_information WHERE username = :username',
      'DELETE FROM user_profile_info WHERE username = :username',
      'DELETE FROM user_follows_info WHERE follower = :username',
      'DELETE FROM user_follows_info WHERE following = :username',
      'DELETE FROM vent_info WHERE creator = :username',
      'DELETE FROM saved_vent_info WHERE creator = :username',
      'DELETE FROM archive_vent_info WHERE creator = :username',
      'DELETE FROM liked_vent_info WHERE liked_by = :username',
      'DELETE FROM vent_comments_info WHERE commented_by = :username',
    ];

    final param = {'username': username};

    for(int i=0; i<queries.length; i++) {
      await conn.execute(queries[i], param);
    }

  }

}