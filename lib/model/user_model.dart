import 'package:get_it/get_it.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/model/local_storage_model.dart';
import 'package:revent/provider/profile_data_provider.dart';
import 'package:revent/provider/profile_posts_provider.dart';
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

}