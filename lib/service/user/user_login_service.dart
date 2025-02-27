import 'package:flutter/material.dart';
import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/main.dart';
import 'package:revent/service/query/user/user_data_getter.dart';
import 'package:revent/model/setup/profile_data_setup.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/model/local_storage_model.dart';
import 'package:revent/service/query/user/user_socials.dart';
import 'package:revent/shared/provider/user_provider.dart';
import 'package:revent/security/hash_model.dart';
import 'package:revent/service/query/user/user_auth_service.dart';
import 'package:revent/shared/widgets/ui_dialog/alert_dialog.dart';
import 'package:revent/shared/widgets/ui_dialog/loading/spinner_loading.dart';
import 'package:revent/model/setup/vent_data_setup.dart';

class UserLoginService {

  final userDataGetter = UserDataGetter();
  final localStorage = LocalStorageModel();

  Future<void> login({
    required BuildContext context,
    required String email, 
    required String auth, 
    required bool isRememberMeChecked
  }) async {

    final username = await userDataGetter.getUsername(email: email);

    if (username == null) {
      CustomAlertDialog.alertDialog('Account not found');
      return;
    }

    final authenticationInformation = await UserAuthService().getAccountAuthentication(
      username: username
    );
      
    final isAuthMatched = HashingModel().computeHash(auth) == authenticationInformation;

    if(!isAuthMatched) {
      CustomAlertDialog.alertDialog('Password is incorrect');
      return;
    }

    if(context.mounted) {
      SpinnerLoading().startLoading(context: context);
    }
      
    await _setUserProfileData(email: email);
    await _setAutoLoginData(isRememberMeChecked: isRememberMeChecked);

    await VentDataSetup().setupForYou()
      .then((_) => NavigatePage.homePage()
    ); 

  }

  Future<void> _setAutoLoginData({required bool isRememberMeChecked}) async {

    final localUserInfo = (await localStorage.readLocalAccountInformation())['username']!;

    if(localUserInfo.isEmpty && isRememberMeChecked) {

      final userData = getIt.userProvider.user;

      await localStorage.setupLocalAccountInformation(
        username: userData.username, email: userData.email, plan: userData.plan
      );

    }

  }

  Future<void> _setUserProfileData({required String email}) async {

    final accountInfo = await userDataGetter.getUserStartupInfo(email: email);
      
    final username = accountInfo['username'];
    final accountPlan = accountInfo['plan'];

    final socialHandles = await UserSocials().getSocialHandles(username: username);

    final userSetup = UserData(
      username: username, 
      email: email, 
      plan: accountPlan,
      socialHandles: {
        'instagram': socialHandles['instagram'] ?? '',
        'twitter': socialHandles['twitter'] ?? '',
        'tiktok': socialHandles['tiktok'] ?? '',
      } 
    );

    await localStorage.setupLocalSocialHandles(socialHandles: socialHandles).then(
      (_) => getIt.userProvider.setUser(userSetup)
    );

    await ProfileDataSetup().setup(username: username);

  }
  
}