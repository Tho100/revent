import 'package:get_it/get_it.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/model/local_storage_model.dart';
import 'package:revent/provider/profile_data_provider.dart';
import 'package:revent/provider/user_data_provider.dart';

class UserModel {

  void signOutUser() async {

    final userData = GetIt.instance<UserDataProvider>();
    final profileData = GetIt.instance<ProfileDataProvider>();

    userData.clearUserData();
    profileData.clearProfileData();

    await LocalStorageModel().deleteLocalData();

    NavigatePage.mainScreenPage();

  }

}