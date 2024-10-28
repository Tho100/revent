import 'package:flutter/material.dart';
import 'package:revent/controllers/auth_controller.dart';
import 'package:revent/data_query/user_registration_service.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/model/disable_whitespace.dart';
import 'package:revent/model/email_validator.dart';
import 'package:revent/security/hash_model.dart';
import 'package:revent/ui_dialog/alert_dialog.dart';
import 'package:revent/ui_dialog/loading/single_text_loading.dart';
import 'package:revent/ui_dialog/snack_bar.dart';
import 'package:revent/widgets/buttons/underlined_button.dart';
import 'package:revent/widgets/header_text.dart';
import 'package:revent/widgets/buttons/main_button.dart';
import 'package:revent/widgets/text_field/auth_textfield.dart';
import 'package:revent/widgets/text_field/main_textfield.dart';

class SignUpPage extends StatefulWidget {

  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => SignUpPageState();

}

class SignUpPageState extends State<SignUpPage> {

  final authController = AuthController();

  final visiblePasswordNotifier = ValueNotifier<bool>(false);

  Future<void> _verifyUserRegistrationInformation({
    required String username,
    required String email,
    required String auth,
  }) async {

    try {

      final authHash = AuthModel().computeHash(auth);
      
      await UserRegistrationService().register(
        username: username,
        hashPassword: authHash,
        email: email,
        context: context
      );

    } catch (err) {
      SnackBarDialog.errorSnack(message: 'Something went wrong.');
    }
    
  }

  Future<void> _processRegistration() async {

    final usernameInput = authController.usernameController.text;
    final emailInput = authController.emailController.text;
    final authInput = authController.passwordController.text;

    if(emailInput.isEmpty || usernameInput.isEmpty || authInput.isEmpty) {
      CustomAlertDialog.alertDialog('Please fill all the fields.');
      return;
    }

    if (usernameInput.contains(RegExp(r'[&%;?]'))) {
      CustomAlertDialog.alertDialogTitle('Sign Up Failed', 'Username cannot contain special characters.');
      return;
    }

    if (authInput.length <= 5) {
      CustomAlertDialog.alertDialogTitle('Sign Up Failed', 'Password must contain more than 5 characters.');
      return;
    }

    if (!EmailValidator().validateEmail(emailInput)) {
      CustomAlertDialog.alertDialogTitle('Sign Up Failed', 'Email address is not valid.');
      return;
    }

    final loadingDialog = SingleTextLoading();

    loadingDialog.startLoading(
      title: 'Creating account...', 
      context: context
    );

    await _verifyUserRegistrationInformation(
      username: usernameInput, 
      email: emailInput, 
      auth: authInput, 
    );

    loadingDialog.stopLoading();
      
  }

  Widget _buildBody(BuildContext context) {

    final mediaQuery = MediaQuery.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: mediaQuery.size.width * 0.05,
        vertical: mediaQuery.size.height * 0.05,
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
            inputFormatters: DisableWhitespaceTextField().disable(),
            controller: authController.usernameController
          ),

          const SizedBox(height: 15),

          MainTextField(
            hintText: 'Enter your email address', 
            inputFormatters: DisableWhitespaceTextField().disable(),
            controller: authController.emailController
          ),

          const SizedBox(height: 15),

          AuthTextField().passwordTextField(
            hintText: 'Enter a password',
            controller: authController.passwordController, 
            visibility: visiblePasswordNotifier
          ),

          const SizedBox(height: 30),

          MainButton(
            text: 'Sign Up',
            onPressed: () async { 
              FocusScope.of(context).unfocus(); 
              await _processRegistration();
            }
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
    authController.dispose();
    visiblePasswordNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _buildBody(context),
    );
  }

}