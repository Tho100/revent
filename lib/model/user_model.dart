import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/main.dart';
import 'package:revent/model/local_storage_model.dart';
import 'package:revent/service/query/general/delete_account_data.dart';

class UserModel {

  void signOutUser() async {

    getIt.userProvider.clearUserData();
    getIt.profileProvider.clearProfileData();
    getIt.profilePostsProvider.clearPostsData();
    getIt.profileSavedProvider.clearPostsData();

    await LocalStorageModel().deleteLocalData();

    NavigatePage.mainScreenPage();

  }

  Future<void> deleteAccountData({required String username}) async {

    await DeleteAccountData().delete(
      username: username
    );

  }

}