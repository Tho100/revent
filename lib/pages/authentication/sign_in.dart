import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/controllers/auth_controller.dart';
import 'package:revent/data_query/user_login_service.dart';
import 'package:revent/model/disable_whitespace.dart';
import 'package:revent/model/email_validator.dart';
import 'package:revent/themes/theme_color.dart';
import 'package:revent/ui_dialog/alert_dialog.dart';
import 'package:revent/ui_dialog/snack_bar.dart';
import 'package:revent/widgets/buttons/underlined_button.dart';
import 'package:revent/widgets/header_text.dart';
import 'package:revent/widgets/buttons/main_button.dart';
import 'package:revent/widgets/text_field/auth_textfield.dart';
import 'package:revent/widgets/text_field/main_textfield.dart';

class SignInPage extends StatefulWidget {

  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => SignInPageState();

}

class SignInPageState extends State<SignInPage> {

  final authController = AuthController();

  final visiblePasswordNotifier = ValueNotifier<bool>(false);
  final isRememberMeCheckedNotifier = ValueNotifier<bool>(true); 

  Future<void> _verifyUserLoginInformation({
    required String email,
    required String auth,
  }) async {

    try {

      await UserLoginService().
        login(email, auth, isRememberMeCheckedNotifier.value, context);

    } catch (err) {
      SnackBarDialog.errorSnack(message: 'Something went wrong.');
    }

  }
  
  Future<void> _processLogin() async {

    final authInput = authController.passwordController.text.trim();
    final emailInput = authController.emailController.text.trim();

    if (!EmailValidator().validateEmail(emailInput)) {
      CustomAlertDialog.alertDialogTitle('Sign In Failed', 'Email address is not valid.');
      return;
    }

    if (emailInput.isEmpty) {
      CustomAlertDialog.alertDialogTitle('Sign In Failed', 'Please enter your email address.');
      return;
    }

    if (authInput.isEmpty) {
      CustomAlertDialog.alertDialogTitle('Sign In Failed', 'Please enter your password.');              
      return;
    }

    await _verifyUserLoginInformation(
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
              title: 'Sign In', 
              subTitle: 'Sign in to your Revent account'
            ),
          ),
          
          const SizedBox(height: 30),

          MainTextField(
            hintText: 'Enter your email address', 
            inputFormatters: DisableWhitespaceTextField().disable(),
            controller: authController.emailController
          ),

          const SizedBox(height: 15),

          AuthTextField().passwordTextField(
            hintText: 'Enter your password',
            controller: authController.passwordController, 
            visibility: visiblePasswordNotifier
          ),

          const SizedBox(height: 15),

          CheckboxTheme(
            data: CheckboxThemeData(
              fillColor: MaterialStateColor.resolveWith(
                (states) => ThemeColor.thirdWhite,
              ),
              checkColor: MaterialStateColor.resolveWith(
                (states) => ThemeColor.secondaryWhite,
              ),
              overlayColor: MaterialStateColor.resolveWith(
                (states) => ThemeColor.secondaryWhite.withOpacity(0.1),
              ),
              side: const BorderSide(
                color: ThemeColor.thirdWhite,
                width: 2.0,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),
            ),
            child: Row(
              children: [
                
                ValueListenableBuilder(
                  valueListenable: isRememberMeCheckedNotifier,
                  builder: (_, value, __) {
                    return Checkbox(
                      value: value,
                      onChanged: (checkedValue) {
                        isRememberMeCheckedNotifier.value = checkedValue ?? true;
                      },
                    );
                  },
                ),

                Text(
                  'Remember Me',
                  style: GoogleFonts.inter(
                    color: const Color.fromARGB(225, 225, 225, 225),
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),

              ],
            ),
          ),

          const SizedBox(height: 30),

          MainButton(
            text: 'Sign In',
            onPressed: () async {
              FocusScope.of(context).unfocus(); 
              await _processLogin();
            }
          ),

          const Spacer(),

          UnderlinedButton(
            text: 'Forgot your password?', 
            onPressed: () {}
          ),
    
        ],
      ),
    );
  }

  @override
  void dispose() {
    authController.dispose();
    visiblePasswordNotifier.dispose();
    isRememberMeCheckedNotifier.dispose();
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