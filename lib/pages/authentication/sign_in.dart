import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/controllers/auth_controller.dart';
import 'package:revent/service/user_login_service.dart';
import 'package:revent/helper/textinput_formatter.dart';
import 'package:revent/helper/email_validator.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/ui_dialog/alert_dialog.dart';
import 'package:revent/ui_dialog/snack_bar.dart';
import 'package:revent/shared/widgets/buttons/underlined_button.dart';
import 'package:revent/shared/widgets/header_text.dart';
import 'package:revent/shared/widgets/buttons/main_button.dart';
import 'package:revent/shared/widgets/text_field/auth_textfield.dart';
import 'package:revent/shared/widgets/text_field/main_textfield.dart';

class SignInPage extends StatefulWidget {

  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();

}

class _SignInPageState extends State<SignInPage> {

  final authController = AuthController();

  final visiblePasswordNotifier = ValueNotifier<bool>(false);
  final isRememberMeCheckedNotifier = ValueNotifier<bool>(true); 

  Future<void> _verifyUserLoginInformation({
    required String email,
    required String auth,
  }) async {

    try {

      await UserLoginService().login(
        context: context, 
        email: email, auth: auth, isRememberMeChecked: isRememberMeCheckedNotifier.value
      );

    } catch (err) {
      SnackBarDialog.errorSnack(message: 'Something went wrong.');
    }

  }
  
  Future<void> _processLogin() async {

    final authInput = authController.passwordController.text;
    final emailInput = authController.emailController.text;

    if (!EmailValidator().validateEmail(emailInput)) {
      CustomAlertDialog.alertDialogTitle('Sign in failed', 'Email address is not valid');
      return;
    }

    if (emailInput.isEmpty) {
      CustomAlertDialog.alertDialogTitle('Sign in failed', 'Please enter your email address');
      return;
    }

    if (authInput.isEmpty) {
      CustomAlertDialog.alertDialogTitle('Sign in failed', 'Please enter your password');              
      return;
    }

    await _verifyUserLoginInformation(
      email: emailInput, 
      auth: authInput, 
    );
    
  }

  Widget _buildRememberMeCheckBox() {
    return CheckboxTheme(
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
              title: 'Sign In', 
              subTitle: 'Sign in to your Revent account'
            ),
          ),
          
          const SizedBox(height: 30),

          MainTextField(
            hintText: 'Enter your email address', 
            inputFormatters: TextInputFormatterModel().disableWhitespaces(),
            controller: authController.emailController
          ),

          const SizedBox(height: 15),

          AuthTextField().passwordTextField(
            hintText: 'Enter your password',
            controller: authController.passwordController, 
            visibility: visiblePasswordNotifier
          ),

          const SizedBox(height: 15),

          _buildRememberMeCheckBox(),

          const SizedBox(height: 30),

          MainButton(
            text: 'Sign In',
            customFontSize: 17,
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
      body: _buildBody(),
    );
  }

}