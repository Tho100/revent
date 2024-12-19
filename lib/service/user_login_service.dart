import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:revent/service/revent_connection_service.dart';
import 'package:revent/service/query/general/user_data_getter.dart';
import 'package:revent/model/setup/profile_data_setup.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/model/local_storage_model.dart';
import 'package:revent/shared/provider/user_data_provider.dart';
import 'package:revent/security/hash_model.dart';
import 'package:revent/security/user_auth.dart';
import 'package:revent/ui_dialog/alert_dialog.dart';
import 'package:revent/ui_dialog/loading/spinner_loading.dart';
import 'package:revent/model/setup/vent_data_setup.dart';

class UserLoginService {

  final userDataGetter = UserDataGetter();
  final localStorage = LocalStorageModel();

  final userData = GetIt.instance<UserDataProvider>();

  Future<void> login({
    required BuildContext context,
    required String email, 
    required String auth, 
    required bool isRememberMeChecked
  }) async {

    final conn = await ReventConnection.connect();

    final username = await userDataGetter.getUsername(email: email, conn: conn);

    if (username == null) {
      CustomAlertDialog.alertDialog('Account not found');
      return;
    }

    final authenticationInformation = await UserAuth().getAccountAuthentication(
      conn: conn, 
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
      
    await _setUserProfileData(conn: conn, email: email);
    await _setAutoLoginData(isRememberMeChecked: isRememberMeChecked);

    await VentDataSetup().setupForYou()
      .then((value) => NavigatePage.homePage()
    ); 

  }

  Future<void> _setAutoLoginData({required bool isRememberMeChecked}) async {

    final localUserInfo = (await localStorage.readLocalAccountInformation())['username']!;

    if(localUserInfo.isEmpty && isRememberMeChecked) {
      await localStorage.setupLocalAccountInformation(
        username: userData.user.username, email: userData.user.email, plan: userData.user.plan
      );
    }

  }

  Future<void> _setUserProfileData({
    required MySQLConnectionPool conn, 
    required String email
  }) async {

    final accountInfo = await userDataGetter.getUserStartupInfo(email: email, conn: conn);
      
    final username = accountInfo['username'];
    final accountPlan = accountInfo['plan'];

    final userSetup = User(
      username: username, 
      email: email, 
      plan: accountPlan, 
    );

    userData.setUser(userSetup);

    await ProfileDataSetup().setup(username: username);

  }
  
}