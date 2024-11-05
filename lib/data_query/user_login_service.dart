import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:revent/connection/revent_connect.dart';
import 'package:revent/data_query/user_data_getter.dart';
import 'package:revent/data_query/user_profile/profile_data_setup.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/model/local_storage_model.dart';
import 'package:revent/provider/user_data_provider.dart';
import 'package:revent/security/hash_model.dart';
import 'package:revent/ui_dialog/alert_dialog.dart';
import 'package:revent/vent_query/vent_data_setup.dart';

class UserLoginService {

  final userDataGetter = UserDataGetter();
  final localStorage = LocalStorageModel();

  final userData = GetIt.instance<UserDataProvider>();

  Future<void> login(String email, String auth, bool isRememberMeChecked, BuildContext context) async {

    final conn = await ReventConnect.initializeConnection();

    final username = await userDataGetter
      .getUsername(email: email, conn: conn);

    if (username == null) {
      if (context.mounted) {
        CustomAlertDialog.alertDialog('Account not found.');
      }
      return;
    }

    final authenticationInformation = await userDataGetter
      .getAccountAuthentication(username: username, conn: conn);
      
    final isAuthMatched = AuthModel().computeHash(auth) == authenticationInformation;

    if(!isAuthMatched) {
      if(context.mounted) {
        CustomAlertDialog.alertDialog('Password is incorrect.');
      }
      return;
    }
      
    await _setUserProfileData(conn: conn, email: email);
    await _setAutoLoginData(isRememberMeChecked: isRememberMeChecked);

    await VentDataSetup().setup()
      .then((value) => NavigatePage.homePage()
    ); 

  }

  Future<void> _setAutoLoginData({required bool isRememberMeChecked}) async {

    final localUserInfo = (await localStorage.readLocalAccountInformation())['username']!;

    if(localUserInfo.isEmpty && isRememberMeChecked) {
      await localStorage.setupLocalAccountInformation(
        userData.user.username, userData.user.email, userData.user.plan
      );
    }

  }

  Future<void> _setUserProfileData({
    required MySQLConnectionPool conn, 
    required String email
  }) async {

    final accountInfo = await userDataGetter
      .getUserStartupInfo(email: email, conn: conn);
      
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