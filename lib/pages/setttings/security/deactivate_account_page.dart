import 'package:flutter/material.dart';
import 'package:revent/global/alert_messages.dart';
import 'package:revent/shared/provider_mixins.dart';
import 'package:revent/controllers/security_auth_controller.dart';
import 'package:revent/security/hash_model.dart';
import 'package:revent/service/query/user/user_auth_service.dart';
import 'package:revent/service/user/user_account_manager.dart';
import 'package:revent/shared/widgets/ui_dialog/alert_dialog.dart';
import 'package:revent/shared/widgets/ui_dialog/snack_bar.dart';
import 'package:revent/shared/widgets/app_bar.dart';
import 'package:revent/shared/widgets/buttons/main_button.dart';
import 'package:revent/shared/widgets/text/header_text.dart';
import 'package:revent/shared/widgets/text_field/password_textfield.dart';

class DeactivateAccountPage extends StatefulWidget {

  const DeactivateAccountPage({super.key});

  @override
  State<DeactivateAccountPage> createState() => _DeleteAccountPageState();

}

class _DeleteAccountPageState extends State<DeactivateAccountPage> with UserProfileProviderService {

  final authController = SecurityAuthController();

  void _deactivateAccountConfirmationDialog() {
    CustomAlertDialog.alertDialogCustomOnPress(
      message: AlertMessages.deactivateAccount, 
      buttonMessage: 'Proceed', 
      onPressedEvent: () async {
        await UserAccountManager().deactivateUserAccount(username: userProvider.user.username).then(
          (_) => Navigator.pop(context)
        );
      } 
    );
  }

  Future<void> _onDeactivateAccountPressed() async {

    try {

      final currentPasswordHash = await UserAuthService().getAccountAuthentication(
        username: userProvider.user.username
      );

      final currentPasswordInput = authController.currentPasswordController.text;
      final currentPasswordInputHash = HashingModel.computeHash(currentPasswordInput);

      if (currentPasswordHash != currentPasswordInputHash) {
        CustomAlertDialog.alertDialog(AlertMessages.incorrectPassword);
        return;
      }

      _deactivateAccountConfirmationDialog();

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
              title: 'Deactivate Account', 
              subTitle: 'Your entire account data will be permanently deleted and this action is irreversible.',
              customTitleSize: 30
            ),
          ),
          
          const SizedBox(height: 35),

          PasswordTextField(
            hintText: 'Enter your password',
            controller: authController.currentPasswordController, 
          ),

          const SizedBox(height: 30),

          MainButton(
            text: 'Deactivate',
            customFontSize: 17,
            onPressed: () async {
              FocusScope.of(context).unfocus(); 
              await _onDeactivateAccountPressed();
            }
          ),
    
        ],
      ),
    );
  }

  @override
  void dispose() {
    authController.dispose();
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