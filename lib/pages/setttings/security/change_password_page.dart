import 'package:flutter/material.dart';
import 'package:revent/global/alert_messages.dart';
import 'package:revent/shared/provider_mixins.dart';
import 'package:revent/controllers/security_auth_controller.dart';
import 'package:revent/security/hash_model.dart';
import 'package:revent/service/query/user/user_auth_service.dart';
import 'package:revent/shared/widgets/ui_dialog/alert_dialog.dart';
import 'package:revent/shared/widgets/ui_dialog/snack_bar.dart';
import 'package:revent/shared/widgets/app_bar.dart';
import 'package:revent/shared/widgets/buttons/main_button.dart';
import 'package:revent/shared/widgets/text/header_text.dart';
import 'package:revent/shared/widgets/text_field/auth_textfield.dart';

class ChangePasswordPage extends StatefulWidget {

  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();

}

class _ChangePasswordPageState extends State<ChangePasswordPage> with UserProfileProviderService {

  final authController = SecurityAuthController();

  final currentPasswordNotifier = ValueNotifier<bool>(false);
  final newPasswordNotifier = ValueNotifier<bool>(false);

  Future<void> _onUpdatePasswordPressed() async {

    try {

      final userAuth = UserAuthService();

      final currentPasswordHash = await userAuth.getAccountAuthentication(
        username: userProvider.user.username
      );

      final hashingModel = HashingModel();

      final currentPasswordInput = authController.currentPasswordController.text.trim();
      final currentPasswordInputHash = hashingModel.computeHash(currentPasswordInput);

      final newPasswordInput = authController.newPasswordController.text.trim();
      final newPasswordInputHash = hashingModel.computeHash(newPasswordInput);

      if (newPasswordInput.isEmpty || currentPasswordInput.isEmpty) {
        CustomAlertDialog.alertDialog("Please fill in both password fields.");
        return;
      }

      if (newPasswordInput == currentPasswordInput) {
        CustomAlertDialog.alertDialog("New password can't be the same as the old one");
        return;
      }

      final passwordMatched = currentPasswordHash == currentPasswordInputHash;

      if (!passwordMatched) {
        CustomAlertDialog.alertDialog('Password is incorrect');
        return;
      }

      await userAuth.updateAccountAuth(
        username: userProvider.user.username, 
        newPasswordHash: newPasswordInputHash
      ).then(
        (_) => CustomAlertDialog.alertDialogTitle('Password Updated', 'Your account password has been updated')
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

          AuthTextField().passwordTextField(
            hintText: 'Enter your current password',
            controller: authController.currentPasswordController, 
            visibility: currentPasswordNotifier
          ),

          const SizedBox(height: 15),

          AuthTextField().passwordTextField(
            hintText: 'Enter a new password',
            controller: authController.newPasswordController, 
            visibility: newPasswordNotifier
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
    authController.dispose();
    newPasswordNotifier.dispose();
    currentPasswordNotifier.dispose();
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