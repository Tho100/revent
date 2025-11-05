import 'package:revent/helper/cache_helper.dart';
import 'package:revent/shared/provider_mixins.dart';
import 'package:revent/model/local_storage_model.dart';

class UserSignOutService with UserProfileProviderService, ProfilePostsProviderService {

  Future<void> signOutUserAccount() async {

    await _clearLocalData().then(
      (_) => _clearMemoryInfo()
    );
    
  }

  void _clearMemoryInfo() {
    userProvider.clearUserData();
    profileProvider.clearProfileData();
    profilePostsProvider.clearPostsData();
    profileSavedProvider.clearPostsData();
  }

  Future<void> _clearLocalData() async {

    final localModel = LocalStorageModel();

    await localModel.deleteAllSearchHistory();
    await localModel.deleteLocalData();
    
    await CacheHelper().clearActivityCache();

  }

}