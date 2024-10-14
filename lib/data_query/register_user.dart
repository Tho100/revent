import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:revent/connection/revent_connect.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/model/local_storage_model.dart';
import 'package:revent/provider/profile_data_provider.dart';
import 'package:revent/provider/user_data_provider.dart';
import 'package:revent/ui_dialog/alert_dialog.dart';
import 'package:revent/vent_query/vent_data_setup.dart';

class RegisterUser {

  final userData = GetIt.instance<UserDataProvider>();
  final profileData = GetIt.instance<ProfileDataProvider>();

  final defaultBioMsg = 'Hello!';

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
        CustomAlertDialog.alertDialog( "Username is taken.");
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
        CustomAlertDialog.alertDialog("Email already exists.");
      }
      return;
    }

    _initializeUserInfo(username: username!, email: email!);

    await _insertUserInfo(hashPassword: hashPassword);

    await VentDataSetup().setup();

    if(context.mounted) {
      NavigatePage.homePage();
    }
  
  }

  Future<void> _insertUserInfo({required String? hashPassword}) async {

    try {
      
      final conn = await ReventConnect.initializeConnection();

      const queries = 
      [
        "INSERT INTO user_information(username, email, password, plan) VALUES (:username, :email, :password, :plan)",
        "INSERT INTO user_profile_info(bio, followers, following, posts, profile_picture, username) VALUES (:bio, :followers, :following, :posts, :profile_pic, :username)"
      ];

      final params = [
        {
          'username': userData.username,
          'email': userData.email,
          'password': hashPassword,
          'plan': 'Basic'
        },
        {
          'bio': defaultBioMsg,
          'followers': 0,
          'following': 0,
          'posts': 0,
          'profile_pic': '',
          'username': userData.username
        }
      ];

      for(int i=0; i < queries.length; i++) {
        await conn.execute(queries[i], params[i]);
      }

      await LocalStorageModel()
        .setupLocalAccountInformation(userData.username, userData.email, "Basic");

    } catch (err) {
      print(err.toString());
    } 

  }  

  void _initializeUserInfo({
    required String username,
    required String email
  }) {

    userData.setUsername(username);
    userData.setEmail(email);
    userData.setAccountPlan("Basic"); 

    profileData.setPosts(0);
    profileData.setFollowers(0);
    profileData.setFollowing(0);
    profileData.setBio(defaultBioMsg);

    profileData.setProfilePicture(Uint8List(0));
    
  }

}