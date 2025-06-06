import 'package:flutter/material.dart';
import 'package:revent/global/alert_messages.dart';
import 'package:revent/helper/providers_service.dart';
import 'package:revent/service/query/general/base_query_service.dart';
import 'package:revent/service/query/user/user_data_registration.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/service/query/user/user_registration_validator.dart';
import 'package:revent/shared/provider/user_provider.dart';
import 'package:revent/shared/widgets/ui_dialog/alert_dialog.dart';
import 'package:revent/model/setup/vents_setup.dart';

class UserRegistrationService extends BaseQueryService with UserProfileProviderService {

  final BuildContext context;

  UserRegistrationService({required this.context});

  Future<void> register({
    required String username,
    required String email,
    required String hashPassword,
  }) async {

    final userValidator = await UserRegistrationValidator(
      username: username, email: email
    ).verifyUsernameAndEmail();

    final usernameExists = userValidator['username_exists']!;
    final emailExists = userValidator['email_exists']!;

    if (_showWarningOnInfoExists(usernameExists, 'Username is taken')) {
      return;
    }

    if (_showWarningOnInfoExists(emailExists, 'Account with this email already exists')) {
      return;
    }

    _setupUserProfileData(username: username, email: email);

    await UserDataRegistration().registerUser(hashPassword: hashPassword);
    
    await VentsSetup().setupLatest()
      .then((_) => NavigatePage.homePage()
    );

  }

  bool _showWarningOnInfoExists(bool showWarning, String alertMessage) {

    if (showWarning) {

      Navigator.pop(context);

      WidgetsBinding.instance.addPostFrameCallback(
        (_) => CustomAlertDialog.alertDialogTitle(AlertMessages.failedSignUp, alertMessage)
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
      socialHandles: {}
    );

    userProvider.setUser(userSetup);

  }

}