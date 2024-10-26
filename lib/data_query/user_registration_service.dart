import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:revent/connection/revent_connect.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/model/local_storage_model.dart';
import 'package:revent/provider/user_data_provider.dart';
import 'package:revent/ui_dialog/alert_dialog.dart';
import 'package:revent/vent_query/vent_data_setup.dart';

class UserRegistrationService {

  final userData = GetIt.instance<UserDataProvider>();

  final defaultBioMsg = 'Hello!';

  Future<void> register({
    required String username,
    required String email,
    required String hashPassword,
    required BuildContext context
  }) async {
    
    final getUsername = await _getDataInfo(
      'SELECT username FROM user_information WHERE username = :username',
      {"username": username}
    ); 

    _showWarningOnDataAlreadyExists(context, getUsername, 'Username is taken.');

    final getEmail = await _getDataInfo(
      'SELECT email FROM user_information WHERE email = :email',
      {"email": email},
    );
    
    _showWarningOnDataAlreadyExists(context, getEmail, 'Email already exists.');
    
    _setUserProfileData(username: username, email: email);

    await _saveUserData(hashPassword: hashPassword);

    await VentDataSetup().setup();

    if(context.mounted) {
      NavigatePage.homePage();
    }
  
  }

  void _showWarningOnDataAlreadyExists(BuildContext context, IResultSet data, String errorMessage) {

    if (data.rows.isNotEmpty) {
      if(context.mounted) {
        Navigator.pop(context);
        CustomAlertDialog.alertDialog(errorMessage);
      }
      return;
    }

  }

  void _setUserProfileData({
    required String username,
    required String email
  }) {

    final userSetup = User(
      username: username, 
      email: email, 
      plan: 'Basic', 
    );

    userData.setUser(userSetup);

  }

  Future<IResultSet> _getDataInfo(String query, Map<String, dynamic> param) async {

    final conn = await ReventConnect.initializeConnection();

    return await conn.execute(query, param);

  }

  Future<void> _saveUserData({required String? hashPassword}) async {

    try {
      
      final conn = await ReventConnect.initializeConnection();

      const queries = 
      [
        "INSERT INTO user_information(username, email, password, plan) VALUES (:username, :email, :password, :plan)",
        "INSERT INTO user_profile_info(bio, followers, following, posts, profile_picture, username) VALUES (:bio, :followers, :following, :posts, :profile_pic, :username)"
      ];

      final params = [
        {
          'username': userData.user.username,
          'email': userData.user.email,
          'password': hashPassword,
          'plan': 'Basic'
        },
        {
          'bio': defaultBioMsg,
          'followers': 0,
          'following': 0,
          'posts': 0,
          'profile_pic': '',
          'username': userData.user.username
        }
      ];

      for(int i=0; i < queries.length; i++) {
        await conn.execute(queries[i], params[i]);
      }

      await LocalStorageModel()
        .setupLocalAccountInformation(userData.user.username, userData.user.email, "Basic");

    } catch (err) {
      print(err.toString());
    } 

  }  

}