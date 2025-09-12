import 'package:flutter/material.dart';
import 'package:revent/global/alert_messages.dart';
import 'package:revent/model/local_storage_model.dart';
import 'package:revent/shared/provider_mixins.dart';
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
    required String password,
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

    final responseCode = await UserDataRegistration().registerUser(password: password);

    if (responseCode == 201) {

      final localStorageModel = LocalStorageModel();

      await localStorageModel.setupAccountInformation(
        username: userProvider.user.username, email: userProvider.user.email
      );

      await localStorageModel.setupThemeInformation(theme: 'dark');

    } 
    
    await VentsSetup().setupLatest()
      .then((_) => NavigatePage.homePage()
    );

  }

  bool _showWarningOnInfoExists(bool showWarning, String alertMessage) {

    if (showWarning) {

      Navigator.pop(context);

      WidgetsBinding.instance.addPostFrameCallback(
        (_) => CustomAlertDialog.alertDialogTitle(AlertMessages.failedSignUpTitle, alertMessage)
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