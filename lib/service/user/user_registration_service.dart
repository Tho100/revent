import 'package:flutter/material.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:revent/helper/providers_service.dart';
import 'package:revent/service/query/general/base_query_service.dart';
import 'package:revent/service/query/user/user_data_registration.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/shared/provider/user_provider.dart';
import 'package:revent/shared/widgets/ui_dialog/alert_dialog.dart';
import 'package:revent/model/setup/vent_data_setup.dart';

class UserRegistrationService extends BaseQueryService with UserProfileProviderService {

  Future<void> register({
    required String username,
    required String email,
    required String hashPassword,
    required BuildContext context,
  }) async {

    final getUsername = await executeQuery(
      'SELECT username FROM user_information WHERE username = :username',
      {'username': username},
    );

    if (_showWarningOnDataAlreadyExists(context, getUsername, 'Username is taken')) {
      return;
    }

    final getEmail = await executeQuery(
      'SELECT email FROM user_information WHERE email = :email',
      {'email': email},
    );

    if (_showWarningOnDataAlreadyExists(context, getEmail, 'Account with this email already exists')) {
      return;
    }

    _setupUserProfileData(username: username, email: email);

    await UserDataRegistration().insert(hashPassword: hashPassword);
    
    await VentDataSetup().setupForYou()
      .then((_) => NavigatePage.homePage()
    );

  }

  bool _showWarningOnDataAlreadyExists(BuildContext context, IResultSet data, String errorMessage) {

    if (data.rows.isNotEmpty) {

      WidgetsBinding.instance.addPostFrameCallback(
        (_) => CustomAlertDialog.alertDialogTitle('Sign up failed', errorMessage)
      );

      return true;

    }

    return false; 

  }

  void _setupUserProfileData({
    required String username,
    required String email
  }) {

    final userSetup = UserData(
      username: username, 
      email: email, 
      plan: 'Basic', 
      socialHandles: {}
    );

    userProvider.setUser(userSetup);

  }

}