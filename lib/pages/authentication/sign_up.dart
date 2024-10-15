import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/controllers/auth_controller.dart';
import 'package:revent/data_query/user_registration_service.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/model/email_validator.dart';
import 'package:revent/security/hash_model.dart';
import 'package:revent/themes/theme_color.dart';
import 'package:revent/ui_dialog/alert_dialog.dart';
import 'package:revent/ui_dialog/loading/single_text_loading.dart';
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

  Future<void> _insertUserRegistrationInformation({
    required String username,
    required String email,
    required String auth,
  }) async {

    try {

      var authHash = AuthModel().computeHash(auth);
      
      await UserRegistrationService().register(
        username: username,
        hashPassword: authHash,
        email: email,
        context: context
      );

    } catch (exceptionConnectionFsc) {
      CustomAlertDialog.alertDialogTitle("Something is wrong...", "No internet connection.");
    }
    
  }

  Future<void> _processRegistration() async {

    final usernameInput = authController.usernameController.text;
    final emailInput = authController.emailController.text;
    final authInput = authController.passwordController.text;

    if(emailInput.isEmpty || usernameInput.isEmpty || authInput.isEmpty) {
      CustomAlertDialog.alertDialog("Please fill all the forms.");
      return;
    }

    if (usernameInput.contains(RegExp(r'[&%;?]'))) {
      CustomAlertDialog.alertDialogTitle("Sign Up Failed", "Username cannot contain special characters.");
      return;
    }

    if (authInput.length <= 5) {
      CustomAlertDialog.alertDialogTitle("Sign Up Failed", "Password must contain more than 5 characters.");
      return;
    }

    if (!EmailValidator().validateEmail(emailInput)) {
      CustomAlertDialog.alertDialogTitle("Sign Up Failed", "Email address is not valid.");
      return;
    }

    final loadingDialog = SingleTextLoading();

    loadingDialog.startLoading(
      title: "Creating account...", 
      context: context
    );

    await _insertUserRegistrationInformation(
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
              title: "Sign Up", 
              subTitle: "Create an account for Revent"
            ),
          ),
          
          const SizedBox(height: 30),

          MainTextField(
            hintText: "Enter a username", 
            maxLength: 24,
            inputFormatters: [
              FilteringTextInputFormatter.deny(RegExp(r'\s')),
            ],
            controller: authController.usernameController
          ),

          const SizedBox(height: 15),

          MainTextField(
            hintText: "Enter your email address", 
            controller: authController.emailController
          ),

          const SizedBox(height: 15),

          AuthTextField().passwordTextField(
            hintText: "Enter a password",
            controller: authController.passwordController, 
            visibility: visiblePasswordNotifier
          ),

          const SizedBox(height: 30),

          MainButton(
            text: "Sign Up",
            onPressed: () async => await _processRegistration()
          ),

          const Spacer(),

          SizedBox(
            height: 35,
            child: Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ThemeColor.black,
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  shape: const StadiumBorder(),
                ),
                onPressed: () => NavigatePage.signInPage(),
                child: Text(
                  "Already have an account?",
                  style: GoogleFonts.inter(
                    color: ThemeColor.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                    decoration: TextDecoration.underline
                  ),
                ),
              ),
            ),
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