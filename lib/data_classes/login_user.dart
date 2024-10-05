import 'package:flutter/material.dart';
import 'package:revent/connection/revent_connect.dart';
import 'package:revent/data_classes/user_data_getter.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/security/hash_model.dart';
import 'package:revent/ui_dialog/alert_dialog.dart';

class LoginUser {

  final userDataGetter = UserDataGetter();

  Future<void> login(String? email, String? auth, BuildContext context) async {

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
        
      /*final justLoading = JustLoading();

      if(context.mounted) {
        justLoading.startLoading(context: context);
      }

      await _getStartupDataFiles(conn, isRememberMeChecked, email!);

      final localUsernames = await LocalStorageModel().readLocalAccountUsernames();

      if(!localUsernames.contains(username) && isRememberMeChecked) {
        await LocalStorageModel().setupLocalAccountUsernames(username);
        await LocalStorageModel().setupLocalAccountEmails(email);
        await LocalStorageModel().setupLocalAccountPlans(userData.accountType);
      }

      justLoading.stopLoading();*/

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
  
}