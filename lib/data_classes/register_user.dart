import 'package:flutter/material.dart';
import 'package:revent/connection/revent_connect.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/ui_dialog/alert_dialog.dart';

class RegisterUser {

  Future<void> register({
    required String? username,
    required String? email,
    required String? hashPassword,
    required BuildContext context
  }) async {
    
    final conn = await ReventConnect.initializeConnection();

    final verifyUsernameQue = await conn.execute(
      "SELECT username FROM user_information WHERE username = :username",
      {"username": username},
    );

    if (verifyUsernameQue.rows.isNotEmpty) {
      if(context.mounted) {
        Navigator.pop(context);
        CustomAlertDialog.alertDialog(context, "Username is taken.");
      }
      return;
    }

    final verifyEmailQue = await conn.execute(
      "SELECT email FROM user_information WHERE email = :email",
      {"email": email},
    );
    
    if (verifyEmailQue.rows.isNotEmpty) {
      if(context.mounted) {
        Navigator.pop(context);
        CustomAlertDialog.alertDialog(context, "Email already exists.");
      }
      return;
    }

    await _insertUserInfo(username, email, hashPassword);

    if(context.mounted) {
      NavigatePage.homePage(context);
    }

    hashPassword = null;
    username = null;
    email = null;
  
  }

  Future<void> _insertUserInfo(String? username, String? email, String? hashPassword) async {

    try {
      
      final conn = await ReventConnect.initializeConnection();

      const query = "INSERT INTO user_information(username, email, password) VALUES (:username, :email, :password)";
      final params = {
        'username': username,
        'email': email,
        'password': hashPassword
      };

      await conn.execute(query, params);
      
      //await setupAutoLogin(userName,email!);

    } catch (duplicatedUsernameException) { } 

  }  

}