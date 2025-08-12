import 'package:flutter/material.dart';
import 'package:revent/controllers/auth_controller.dart';
import 'package:revent/global/alert_messages.dart';
import 'package:revent/service/user/user_registration_service.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/helper/input_formatters.dart';
import 'package:revent/helper/input_validator.dart';
import 'package:revent/security/hash_model.dart';
import 'package:revent/shared/widgets/ui_dialog/alert_dialog.dart';
import 'package:revent/shared/widgets/ui_dialog/loading/single_text_loading.dart';
import 'package:revent/shared/widgets/ui_dialog/snack_bar.dart';
import 'package:revent/shared/widgets/buttons/underlined_button.dart';
import 'package:revent/shared/widgets/text/header_text.dart';
import 'package:revent/shared/widgets/buttons/main_button.dart';
import 'package:revent/shared/widgets/text_field/password_textfield.dart';
import 'package:revent/shared/widgets/text_field/main_textfield.dart';

class SignUpPage extends StatefulWidget {

  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();

}

class _SignUpPageState extends State<SignUpPage> {

  Future<void> _registerUser({
    required String username,
    required String email,
    required String auth,
  }) async {

    try {

      final authHash = HashingModel.computeHash(auth);
      
      await UserRegistrationService(context: context).register(
        username: username,
        passwordHash: authHash,
        email: email,
      );

    } catch (_) {
      SnackBarDialog.errorSnack(message: AlertMessages.defaultError);
    }
    
  }

  Future<void> _processRegistration() async {

    final usernameInput = AuthController.usernameController.text;
    final emailInput = AuthController.emailController.text;
    final authInput = AuthController.passwordController.text;

    if (emailInput.isEmpty || usernameInput.isEmpty || authInput.isEmpty) {
      CustomAlertDialog.alertDialog(AlertMessages.registrationFieldsEmpty);
      return;
    }

    if (!InputValidator.validateUsernameFormat(usernameInput)) {
      CustomAlertDialog.alertDialogTitle(AlertMessages.failedSignUpTitle, AlertMessages.invalidUsername);
      return;
    }

    if (authInput.length <= 5) {
      CustomAlertDialog.alertDialogTitle(AlertMessages.failedSignUpTitle, AlertMessages.invalidPasswordLength);
      return;
    }

    if (!InputValidator.validateEmailFormat(emailInput)) {
      CustomAlertDialog.alertDialogTitle(AlertMessages.failedSignUpTitle, AlertMessages.invalidEmailAddr);
      return;
    }

    SingleTextLoading(context: context).startLoading(
      title: 'Creating account...', 
    );

    await _registerUser(
      username: usernameInput, 
      email: emailInput, 
      auth: authInput, 
    );
      
  }

  Widget _buildBody() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.05,
        vertical: MediaQuery.of(context).size.height * 0.05,
      ),
      child: Column(
        children: [
  
          const Padding(
            padding: EdgeInsets.only(left: 4.0, top: 22.0),
            child: HeaderText(
              title: 'Sign Up', 
              subTitle: 'Create an account for Revent'
            ),
          ),
          
          const SizedBox(height: 30),

          MainTextField(
            hintText: 'Enter a username', 
            maxLength: 24,
            textInputAction: TextInputAction.next,
            inputFormatters: InputFormatters.usernameFormatter(),
            controller: AuthController.usernameController,
          ),

          const SizedBox(height: 15),

          MainTextField(
            hintText: 'Enter your email address', 
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.emailAddress,
            inputFormatters: InputFormatters.noSpaces(),
            controller: AuthController.emailController,
          ),

          const SizedBox(height: 15),

          PasswordTextField(
            hintText: 'Enter a password',
            controller: AuthController.passwordController, 
          ),

          const SizedBox(height: 30),

          MainButton(
            text: 'Sign Up',
            customFontSize: 17,
            onPressed: () async { 
              FocusScope.of(context).unfocus(); 
              await _processRegistration();
            },
          ),

          const Spacer(),

          UnderlinedButton(
            text: 'Already have an account?', 
            onPressed: () => NavigatePage.signInPage()
          ),
    
        ],
      ),
    );
  }

  @override
  void dispose() {
    AuthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _buildBody(),
    );
  }

}