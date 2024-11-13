import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:revent/connection/revent_connect.dart';
import 'package:revent/controllers/security_auth_controller.dart';
import 'package:revent/model/user_model.dart';
import 'package:revent/provider/user_data_provider.dart';
import 'package:revent/security/hash_model.dart';
import 'package:revent/security/user_auth.dart';
import 'package:revent/ui_dialog/alert_dialog.dart';
import 'package:revent/ui_dialog/snack_bar.dart';
import 'package:revent/widgets/app_bar.dart';
import 'package:revent/widgets/buttons/main_button.dart';
import 'package:revent/widgets/header_text.dart';
import 'package:revent/widgets/text_field/auth_textfield.dart';

class DeleteAccountPage extends StatefulWidget {

  const DeleteAccountPage({super.key});

  @override
  State<DeleteAccountPage> createState() => DeleteAccountPageState();

}

class DeleteAccountPageState extends State<DeleteAccountPage> {

  final authController = SecurityAuthController();

  final currentPasswordNotifier = ValueNotifier<bool>(false);

  final userAuth = UserAuth();
  final userModel = UserModel();

  final userData = GetIt.instance<UserDataProvider>();

  void _deleteAccountConfirmation() {
    CustomAlertDialog.alertDialogCustomOnPress(
      message: 'Delete your account?', 
      buttonMessage: 'Delete', 
      onPressedEvent: () async {
        Navigator.pop(context);
        await userModel.deleteAccountData(username: userData.user.username)
          .then((value) => userModel.signOutUser()
        );
      } 
    );
  }

  Future<void> _deleteOnPressed() async {

    try {

      final conn = await ReventConnect.initializeConnection();

      final currentPasswordHash = await userAuth.getAccountAuthentication(
        conn: conn, 
        username: userData.user.username
      );

      final currentPasswordInput = authController.currentPasswordController.text;
      final currentPasswordInputHash = AuthModel().computeHash(currentPasswordInput);

      if(currentPasswordHash == currentPasswordInputHash) {
        _deleteAccountConfirmation();
        
      } else {
        CustomAlertDialog.alertDialog('Password is incorrect');

      }

    } catch (err) {
      SnackBarDialog.errorSnack(message: 'Something went wrong');
    }
    
  }

  Widget _buildBody(BuildContext context) {
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
        title: ''
      ).buildAppBar(),
      resizeToAvoidBottomInset: false,
      body: _buildBody(context),
    );
  }
  
}