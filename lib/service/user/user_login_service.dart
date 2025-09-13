import 'package:flutter/material.dart';
import 'package:revent/global/alert_messages.dart';
import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/main.dart';
import 'package:revent/service/activity_service.dart';
import 'package:revent/service/query/user/user_data_getter.dart';
import 'package:revent/model/setup/profile_data_setup.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/model/local_storage_model.dart';
import 'package:revent/shared/provider/user_provider.dart';
import 'package:revent/service/query/user/user_auth_service.dart';
import 'package:revent/shared/widgets/ui_dialog/alert_dialog.dart';
import 'package:revent/shared/widgets/ui_dialog/loading/spinner_loading.dart';
import 'package:revent/model/setup/vents_setup.dart';

class UserLoginService {

  final BuildContext context;

  UserLoginService({required this.context});

  final _userDataGetter = UserDataGetter();

  Future<void> login({
    required String email, 
    required String password, 
    required bool isRememberMeChecked
  }) async {

    final responses = await UserAuthService().getLoginAuthentication(
      email: email, password: password
    );

    final responseCode = responses['status_code'];

    if (responseCode == 404) {
      CustomAlertDialog.alertDialog(AlertMessages.accountNotFound);
      return;
    } 

    if (responseCode == 401) {
      CustomAlertDialog.alertDialog(AlertMessages.incorrectPassword);
      return;      
    }

    if (responseCode == 200) {

      if (context.mounted) {
        SpinnerLoading(context: context).startLoading();
      }
        
      await _setUserProfileData(email: email, username: responses['body']['username']);

      await _setAutoLoginData(isRememberMeChecked: isRememberMeChecked);

      await VentsSetup().setupLatest().then(
        (_) => NavigatePage.homePage()
      ); 

      await ActivityService().initializeActivities(isLogin: true);

    } 

  }

  Future<void> _setAutoLoginData({required bool isRememberMeChecked}) async {

    final localStorage = LocalStorageModel();

    final localUserInfo = (await localStorage.readAccountInformation())['username']!;

    if (localUserInfo.isEmpty && isRememberMeChecked) {

      final userData = getIt.userProvider.user;

      await localStorage.setupAccountInformation(
        username: userData.username, email: userData.email
      );

    }

  }

  Future<void> _setUserProfileData({
    required String email,
    required String username
  }) async {
    
    final socialHandles = await _userDataGetter.getSocialHandles(username: username);

    final userSetup = UserData(
      username: username, 
      email: email, 
      socialHandles: {
        'instagram': socialHandles['instagram'] ?? '',
        'twitter': socialHandles['twitter'] ?? '',
        'tiktok': socialHandles['tiktok'] ?? '',
      } 
    );

    getIt.userProvider.setUser(userSetup);

    await ProfileDataSetup().setup(username: username);

  }
  
}