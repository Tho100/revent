import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:revent/connection/revent_connect.dart';
import 'package:revent/data_classes/user_data_getter.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/model/local_storage_model.dart';
import 'package:revent/provider/user_data_provider.dart';
import 'package:revent/security/hash_model.dart';
import 'package:revent/ui_dialog/alert_dialog.dart';

class LoginUser {

  final userDataGetter = UserDataGetter();
  final localStorage = LocalStorageModel();

  final userData = GetIt.instance<UserDataProvider>();

  Future<void> login(String? email, String? auth, bool isRememberMeChecked, BuildContext context) async {

    final conn = await ReventConnect.initializeConnection();

    try {

      final username = await userDataGetter
        .getUsername(email: email, conn: conn);

      if (username == null) {
        if (context.mounted) {
          CustomAlertDialog.alertDialog(context, "Account not found.");
        }
        return;
      }

      final authenticationInformation = await userDataGetter
        .getAccountAuthentication(username: username, conn: conn);
        
      final isAuthMatched = AuthModel().computeHash(auth!) == authenticationInformation;

      if(!isAuthMatched) {
        if(context.mounted) {
          CustomAlertDialog.alertDialog(context, "Password is incorrect.");
        }
        return;
      }
        
      await _initializeUserInfo(conn: conn, email: email!);
      await _initializeRememberMe(isRememberMeChecked: isRememberMeChecked);

      if(context.mounted) {
        NavigatePage.homePage(context);
      }

    } catch (err) {

      if(context.mounted) {
        CustomAlertDialog.alertDialogTitle(context, "Something is wrong...", "No internet connection.");
      }
      
    } finally {
      await conn.close();
    }

  }

  Future<void> _initializeRememberMe({required bool isRememberMeChecked}) async {

    final localUserInfo = (await localStorage.readLocalAccountInformation())['username']!;

    if(localUserInfo.isEmpty && isRememberMeChecked) {
      await localStorage
        .setupLocalAccountInformation(userData.username, userData.email, userData.accountType);
    }

  }

  Future<void> _initializeUserInfo({
    required MySQLConnectionPool conn, 
    required String email
  }) async {

    final accountInfo = await userDataGetter
      .getAccountTypeAndUsername(email: email, conn: conn);
      
    final username = accountInfo[0]!;
    final accountPlan = accountInfo[1]!;

    userData.setUsername(username);
    userData.setEmail(email);
    userData.setAccountType(accountPlan);

  }
  
}