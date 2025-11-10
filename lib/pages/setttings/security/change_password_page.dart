import 'package:flutter/material.dart';
import 'package:revent/global/alert_messages.dart';
import 'package:revent/global/validation_limits.dart';
import 'package:revent/shared/provider_mixins.dart';
import 'package:revent/controllers/security_auth_controller.dart';
import 'package:revent/service/user/auth_service.dart';
import 'package:revent/shared/widgets/password_requirement_status.dart';
import 'package:revent/shared/widgets/dialog/alert_dialog.dart';
import 'package:revent/shared/widgets/dialog/snack_bar.dart';
import 'package:revent/shared/widgets/app_bar.dart';
import 'package:revent/shared/widgets/buttons/main_button.dart';
import 'package:revent/shared/widgets/text/header_text.dart';
import 'package:revent/shared/widgets/text_field/password_textfield.dart';

class ChangePasswordPage extends StatefulWidget {

  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();

}

class _ChangePasswordPageState extends State<ChangePasswordPage> with 
  UserProfileProviderService,
  SecurityAuthController {

  final isContinueButtonEnabledNotifier = ValueNotifier<bool>(false);
  final showPasswordRequirements = ValueNotifier<bool>(false);

  final currentPasswordFocus = FocusNode();
  final newPasswordFocus = FocusNode();

  void _checkFormFilled() {

    final isFilled = 
      currentPasswordController.text.trim().isNotEmpty &&
      newPasswordController.text.trim().isNotEmpty;

    final shouldEnable = 
      isFilled && 
      newPasswordController.text.length >= ValidationLimits.minPasswordLength;

    if (isFilled != isContinueButtonEnabledNotifier.value) {
      isContinueButtonEnabledNotifier.value = shouldEnable;
    }
    
  }

  void _addPasswordFocusListener() {
    newPasswordFocus.addListener(() {
      if (newPasswordFocus.hasFocus) {
        showPasswordRequirements.value = true;
      }
    });
  }

  Future<void> _onUpdatePasswordPressed() async {

    try {

      final currentPasswordInput = currentPasswordController.text.trim();
      final newPasswordInput = newPasswordController.text.trim();

      if (newPasswordInput.isEmpty || currentPasswordInput.isEmpty) {
        CustomAlertDialog.alertDialog(AlertMessages.emptyPasswordFields);
        return;
      }

      if (newPasswordInput == currentPasswordInput) {
        CustomAlertDialog.alertDialog(AlertMessages.matchingPasswordFields);
        return;
      }

      final verifyAuthResponse = await UserAuthService.verifyUserAuth(
        username: userProvider.user.username, password: currentPasswordInput
      );

      if (verifyAuthResponse['status_code'] == 401) {
        CustomAlertDialog.alertDialog(AlertMessages.incorrectPassword);
        return;
      }

      final updateAuthResponse = await UserAuthService.updateAccountAuth(
        username: userProvider.user.username, 
        newPassword: newPasswordInput
      );

      if (updateAuthResponse['status_code'] == 400) {
        CustomAlertDialog.alertDialog(AlertMessages.matchingPasswordFields);
        return;
      }

      if (updateAuthResponse['status_code'] != 200) {
        SnackBarDialog.errorSnack(message: AlertMessages.defaultError);
        return;
      }

      CustomAlertDialog.alertDialogTitle(
        AlertMessages.passwordUpdatedTitle, AlertMessages.passwordHasBeenUpdated
      );

    } catch (_) {
      SnackBarDialog.errorSnack(message: AlertMessages.defaultError);
    }
    
  }

  Widget _passwordRequirements() {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, top: 16.0),
      child: Column(
        children: [
    
          PasswordRequirementStatus(
            isValid: isContinueButtonEnabledNotifier, 
            showRequirements: showPasswordRequirements,
            requirement: 'At least ${ValidationLimits.minPasswordLength} characters'
          )
    
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.sizeOf(context).width * 0.05,
      ),
      child: Column(
        children: [
  
          const Padding(
            padding: EdgeInsets.only(left: 4.0),
            child: HeaderText(
              title: 'Change Password',
              subTitle: ''
            ),
          ),
          
          const SizedBox(height: 10),

          PasswordTextField(
            hintText: 'Enter your current password',
            textInputAction: TextInputAction.next,
            controller: currentPasswordController, 
            focusNode: currentPasswordFocus,
            onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(newPasswordFocus),
          ),

          const SizedBox(height: 15),

          PasswordTextField(
            hintText: 'Enter a new password',
            controller: newPasswordController, 
            focusNode: newPasswordFocus,
          ),

          const SizedBox(height: 8),

          _passwordRequirements(),

          const SizedBox(height: 30),

          ValueListenableBuilder(
            valueListenable: isContinueButtonEnabledNotifier, // TODO: Update to isUpdate...
            builder: (_, isEnabled, __) {
              return MainButton(
                enabled: isEnabled,
                text: 'Update',
                customFontSize: 17,
                onPressed: () async {
                  FocusScope.of(context).unfocus(); 
                  await _onUpdatePasswordPressed();
                }
              );
            }
          ),
    
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    currentPasswordController.addListener(_checkFormFilled);
    newPasswordController.addListener(_checkFormFilled);
    _addPasswordFocusListener();
  }

  @override
  void dispose() {
    disposeControllers();
    isContinueButtonEnabledNotifier.dispose();
    currentPasswordFocus.dispose();
    newPasswordFocus.dispose();
    showPasswordRequirements.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context: context, 
      ).buildAppBar(),
      resizeToAvoidBottomInset: false,
      body: _buildBody(),
    );
  }
  
}