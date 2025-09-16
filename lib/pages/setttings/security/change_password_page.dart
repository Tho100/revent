import 'package:flutter/material.dart';
import 'package:revent/global/alert_messages.dart';
import 'package:revent/shared/provider_mixins.dart';
import 'package:revent/controllers/security_auth_controller.dart';
import 'package:revent/service/query/user/user_auth_service.dart';
import 'package:revent/shared/widgets/ui_dialog/alert_dialog.dart';
import 'package:revent/shared/widgets/ui_dialog/snack_bar.dart';
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

      final isPasswordMatched = await UserAuthService.verifyUserAuth(
        username: userProvider.user.username, password: currentPasswordInput
      );

      if (!isPasswordMatched) {
        CustomAlertDialog.alertDialog(AlertMessages.incorrectPassword);
        return;
      }

      await UserAuthService.updateAccountAuth(
        username: userProvider.user.username, 
        newPassword: newPasswordInput
      ).then(
        (_) => CustomAlertDialog.alertDialogTitle(
          AlertMessages.passwordUpdatedTitle, AlertMessages.passwordHasBeenUpdated
        )
      );

    } catch (_) {
      SnackBarDialog.errorSnack(message: AlertMessages.defaultError);
    }
    
  }

  Widget _buildBody() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.05,
      ),
      child: Column(
        children: [
  
          const Padding(
            padding: EdgeInsets.only(left: 4.0),
            child: HeaderText(
              title: 'Update Password', 
              subTitle: ''
            ),
          ),
          
          const SizedBox(height: 10),

          PasswordTextField(
            hintText: 'Enter your current password',
            controller: currentPasswordController, 
          ),

          const SizedBox(height: 15),

          PasswordTextField(
            hintText: 'Enter a new password',
            controller: newPasswordController, 
          ),

          const SizedBox(height: 30),

          MainButton(
            text: 'Update',
            customFontSize: 17,
            onPressed: () async {
              FocusScope.of(context).unfocus(); 
              await _onUpdatePasswordPressed();
            }
          ),
    
        ],
      ),
    );
  }

  @override
  void dispose() {
    disposeControllers();
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