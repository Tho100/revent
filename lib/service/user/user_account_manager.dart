import 'package:revent/helper/cache_helper.dart';
import 'package:revent/shared/provider_mixins.dart';
import 'package:revent/model/local_storage_model.dart';
import 'package:revent/service/query/general/delete_account_data.dart';

class UserAccountManager with UserProfileProviderService, ProfilePostsProviderService {

  Future<void> signOutUserAccount() async {

    userProvider.clearUserData();
    profileProvider.clearProfileData();
    profilePostsProvider.clearPostsData();
    profileSavedProvider.clearPostsData();

    final localModel = LocalStorageModel();

    await localModel.deleteAllSearchHistory();
    await localModel.deleteLocalData();
    
    await CacheHelper().clearNotificationCache();

  }

  Future<void> deactivateUserAccount({required String username}) async {
    await DeleteAccountData().delete(username: username).then(
      (_) => signOutUserAccount()
    );
  }

}