import 'package:revent/helper/navigate_page.dart';
import 'package:revent/helper/providers_service.dart';
import 'package:revent/model/local_storage_model.dart';
import 'package:revent/service/query/general/delete_account_data.dart';

class UserAccountManager with UserProfileProviderService, ProfilePostsProviderService {

  void signOutUser() async {

    userProvider.clearUserData();
    profileProvider.clearProfileData();
    profilePostsProvider.clearPostsData();
    profileSavedProvider.clearPostsData();

    final localModel = LocalStorageModel();

    await localModel.deleteAllSearchHistory();

    await localModel.deleteLocalData().then(
      (_) => NavigatePage.mainScreenPage()
    );

  }

  Future<void> deleteAccountData({required String username}) async {

    await DeleteAccountData().delete(username: username).then(
      (_) => signOutUser()
    );

  }

}