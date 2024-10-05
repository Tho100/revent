import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/data_classes/register_user.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/model/email_validator.dart';
import 'package:revent/security/hash_model.dart';
import 'package:revent/themes/theme_color.dart';
import 'package:revent/ui_dialog/alert_dialog.dart';
import 'package:revent/ui_dialog/loading/single_text_loading.dart';
import 'package:revent/widgets/header_text.dart';
import 'package:revent/widgets/main_button.dart';
import 'package:revent/widgets/text_field/auth_textfield.dart';
import 'package:revent/widgets/text_field/main_textfield.dart';

class SignUpPage extends StatefulWidget {

  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => SignUpPageState();

}

class SignUpPageState extends State<SignUpPage> {

  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final visiblePasswordNotifier = ValueNotifier<bool>(false);

  Future<void> _insertUserRegistrationInformation({
    required String username,
    required String email,
    required String auth,
  }) async {

    try {

      var authHash = AuthModel().computeHash(auth);
      
      await RegisterUser().register(
        username: username,
        hashPassword: authHash,
        email: email,
        context: context
      );

    } catch (exceptionConnectionFsc) {
      CustomAlertDialog.alertDialogTitle(context, "Something is wrong...", "No internet connection.");
    }
    
  }

  Future<void> _processRegistration() async {

    var usernameInput = usernameController.text;
    var emailInput = emailController.text;
    var authInput = passwordController.text;

    if(emailInput.isEmpty && usernameInput.isEmpty && authInput.isEmpty) {
      CustomAlertDialog.alertDialog(context, "Please fill all the required forms.");
      return;
    }

    if (usernameInput.contains(RegExp(r'[&%;?]'))) {
      CustomAlertDialog.alertDialogTitle(context, "Sign Up Failed", "Username cannot contain special characters.");
      return;
    }

    if (authInput.contains(RegExp(r'[?!]'))) {
      CustomAlertDialog.alertDialogTitle(context, "Sign Up Failed", "Password cannot contain special characters.");
      return;
    }

    if (authInput.length <= 5) {
      CustomAlertDialog.alertDialogTitle(context, "Sign Up Failed", "Password must contain more than 5 characters.");
      return;
    }

    if (!EmailValidator().validateEmail(emailInput)) {
      CustomAlertDialog.alertDialogTitle(context, "Sign Up Failed", "Email address is not valid.");
      return;
    }

    if (usernameInput.isEmpty) {
      CustomAlertDialog.alertDialogTitle(context, "Sign Up Failed","Please enter a username.");
      return;
    }

    if (authInput.isEmpty) {
      CustomAlertDialog.alertDialog(context, "Please enter a password.");
      return;
    }

    if (emailInput.isEmpty) {
      CustomAlertDialog.alertDialog(context, "Please enter your email.");
      return;
    }

    /*userData.setUsername(usernameInput);
    userData.setEmail(emailInput);
    userData.setAccountType("Basic");
    
    tempData.setOrigin("homeFiles");*/
    
    final singleTextLoading = SingleTextLoading();

    singleTextLoading.startLoading(
      title: "Creating account...", 
      context: context
    );

    await _insertUserRegistrationInformation(
      username: usernameInput, 
      email: emailInput, 
      auth: authInput, 
    );
      
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
            maxLength: 32,
            controller: usernameController
          ),

          const SizedBox(height: 15),

          MainTextField(
            hintText: "Enter your email address", 
            controller: emailController
          ),

          const SizedBox(height: 15),

          AuthTextField().passwordTextField(
            hintText: "Enter a password",
            controller: passwordController, 
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
                onPressed: () => NavigatePage.signInPage(context),
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
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
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