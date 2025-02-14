import 'package:flutter/material.dart';
import 'package:revent/global/alert_messages.dart';
import 'package:revent/helper/providers_service.dart';
import 'package:revent/controllers/security_auth_controller.dart';
import 'package:revent/model/user/user_account_manager.dart';
import 'package:revent/security/hash_model.dart';
import 'package:revent/service/query/user/user_auth_service.dart';
import 'package:revent/shared/widgets/ui_dialog/alert_dialog.dart';
import 'package:revent/shared/widgets/ui_dialog/snack_bar.dart';
import 'package:revent/shared/widgets/app_bar.dart';
import 'package:revent/shared/widgets/buttons/main_button.dart';
import 'package:revent/shared/widgets/header_text.dart';
import 'package:revent/shared/widgets/text_field/auth_textfield.dart';

class DeleteAccountPage extends StatefulWidget {

  const DeleteAccountPage({super.key});

  @override
  State<DeleteAccountPage> createState() => _DeleteAccountPageState();

}

class _DeleteAccountPageState extends State<DeleteAccountPage> with UserProfileProviderService {

  final authController = SecurityAuthController();

  final currentPasswordNotifier = ValueNotifier<bool>(false);

  void _deleteAccountConfirmation() {
    CustomAlertDialog.alertDialogCustomOnPress(
      message: 'Delete your account?', 
      buttonMessage: 'Delete', 
      onPressedEvent: () async {
        Navigator.pop(context);
        await UserAccountManager().deleteAccountData(username: userProvider.user.username);
      } 
    );
  }

  Future<void> _deleteOnPressed() async {

    try {

      final currentPasswordHash = await UserAuthService().getAccountAuthentication(
        username: userProvider.user.username
      );

      final currentPasswordInput = authController.currentPasswordController.text;
      final currentPasswordInputHash = HashingModel().computeHash(currentPasswordInput);

      if(currentPasswordHash == currentPasswordInputHash) {
        _deleteAccountConfirmation();
        
      } else {
        CustomAlertDialog.alertDialog('Password is incorrect');

      }

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
              title: 'Delete Account', 
              subTitle: 'Your entire account data will be permanently deleted and this action is irreversible.'
            ),
          ),
          
          const SizedBox(height: 35),

          AuthTextField().passwordTextField(
            hintText: 'Enter your current password',
            controller: authController.currentPasswordController, 
            visibility: currentPasswordNotifier
          ),

          const SizedBox(height: 30),

          MainButton(
            text: 'Delete',
            customFontSize: 17,
            onPressed: () async {
              FocusScope.of(context).unfocus(); 
              await _deleteOnPressed();
            }
          ),
    
        ],
      ),
    );
  }

  @override
  void dispose() {
    authController.dispose();
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