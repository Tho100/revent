import 'package:flutter/material.dart';
import 'package:revent/global/alert_messages.dart';
import 'package:revent/model/local_storage_model.dart';
import 'package:revent/shared/api/api_client.dart';
import 'package:revent/shared/api/api_path.dart';
import 'package:revent/shared/provider_mixins.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/service/user/verify_service.dart';
import 'package:revent/shared/provider/user_provider.dart';
import 'package:revent/shared/widgets/dialog/alert_dialog.dart';
import 'package:revent/model/setup/vents_setup.dart';

class UserRegistrationService with UserProfileProviderService {

  final BuildContext context;

  UserRegistrationService({required this.context});

  Future<void> register({
    required String username,
    required String email,
    required String password,
  }) async {

    final userValidator = await UserVerifyService().usernameOrEmailExists(
      username: username, email: email
    );

    final usernameExists = userValidator['username_exists']!;
    final emailExists = userValidator['email_exists']!;

    if (_showWarningOnInfoExists(usernameExists || emailExists, 'Username or email already in use')) {
      return;
    }
    
    _setupUserProfileData(username: username, email: email);

    final responseCode = await _registerUser(password);

    if (responseCode == 201) {

      final localStorageModel = LocalStorageModel();

      await localStorageModel.setupAccountInformation(
        username: userProvider.user.username, email: userProvider.user.email
      );

      await localStorageModel.setupThemeInformation(theme: 'dark');

      await VentsSetup().setupLatest()
        .then((_) => NavigatePage.homePage()
      );

    } 

  }

  Future<int> _registerUser(password) async {
    
    final response = await ApiClient.post(ApiPath.register, {
      'username': userProvider.user.username,
      'email': userProvider.user.email,
      'password': password
    });

    return response.statusCode;

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