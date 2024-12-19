import 'package:get_it/get_it.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/model/local_storage_model.dart';
import 'package:revent/service/query/delete_account_data.dart';
import 'package:revent/shared/provider/profile/profile_data_provider.dart';
import 'package:revent/shared/provider/profile/profile_posts_provider.dart';
import 'package:revent/shared/provider/user_data_provider.dart';

class UserModel {

  void signOutUser() async {

    GetIt.instance<UserDataProvider>().clearUserData();
    GetIt.instance<ProfileDataProvider>().clearProfileData();
    GetIt.instance<ProfilePostsProvider>().clearPostsData();

    await LocalStorageModel().deleteLocalData();

    NavigatePage.mainScreenPage();

  }

  Future<void> deleteAccountData({required String username}) async {

    await DeleteAccountData().delete(
      username: username
    );

  }

}