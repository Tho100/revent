import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:revent/service/revent_connection_service.dart';
import 'package:revent/data_query/user_data_registration.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/provider/user_data_provider.dart';
import 'package:revent/ui_dialog/alert_dialog.dart';
import 'package:revent/helper/setup/vent_data_setup.dart';

class UserRegistrationService {

  final userData = GetIt.instance<UserDataProvider>();

  Future<void> register({
    required String username,
    required String email,
    required String hashPassword,
    required BuildContext context,
  }) async {

    final getUsername = await _getDataInfo(
      'SELECT username FROM user_information WHERE username = :username',
      {'username': username},
    );

    if (_showWarningOnDataAlreadyExists(context, getUsername, 'Username is taken')) {
      return;
    }

    final getEmail = await _getDataInfo(
      'SELECT email FROM user_information WHERE email = :email',
      {'email': email},
    );

    if (_showWarningOnDataAlreadyExists(context, getEmail, 'Account with this email already exists')) {
      return;
    }

    _setUserProfileData(username: username, email: email);

    await UserDataRegistration().insert(hashPassword: hashPassword);
    
    await VentDataSetup().setupForYou()
      .then((value) => NavigatePage.homePage()
    );

  }

  bool _showWarningOnDataAlreadyExists(BuildContext context, IResultSet data, String errorMessage) {

    if (data.rows.isNotEmpty) {

      WidgetsBinding.instance.addPostFrameCallback((_) {
        CustomAlertDialog.alertDialogTitle('Sign up failed', errorMessage);
      });

      return true;

    }

    return false; 

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

    final conn = await ReventConnection.connect();

    return await conn.execute(query, param);

  }

}