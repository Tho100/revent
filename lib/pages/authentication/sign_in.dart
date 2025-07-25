import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/controllers/auth_controller.dart';
import 'package:revent/global/alert_messages.dart';
import 'package:revent/service/user/user_login_service.dart';
import 'package:revent/helper/input_formatters.dart';
import 'package:revent/helper/input_validator.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/widgets/ui_dialog/alert_dialog.dart';
import 'package:revent/shared/widgets/ui_dialog/snack_bar.dart';
import 'package:revent/shared/widgets/buttons/underlined_button.dart';
import 'package:revent/shared/widgets/text/header_text.dart';
import 'package:revent/shared/widgets/buttons/main_button.dart';
import 'package:revent/shared/widgets/text_field/password_textfield.dart';
import 'package:revent/shared/widgets/text_field/main_textfield.dart';

class SignInPage extends StatefulWidget {

  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();

}

class _SignInPageState extends State<SignInPage> {

  final authController = AuthController();

  final isRememberMeCheckedNotifier = ValueNotifier<bool>(true); 

  Future<void> _loginUser({
    required String email,
    required String auth,
  }) async {

    try {

      await UserLoginService(context: context).login(
        email: email, auth: auth, isRememberMeChecked: isRememberMeCheckedNotifier.value
      );

    } catch (_) {
      SnackBarDialog.errorSnack(message: AlertMessages.defaultError);
    }

  }
  
  Future<void> _processLogin() async {

    final authInput = authController.passwordController.text;
    final emailInput = authController.emailController.text;

    if (emailInput.isEmpty) {
      CustomAlertDialog.alertDialogTitle(AlertMessages.failedSignIn, 'Please enter your email address');
      return;
    }

    if (!InputValidator.validateEmailFormat(emailInput)) {
      CustomAlertDialog.alertDialogTitle(AlertMessages.failedSignIn, 'Email address is not valid');
      return;
    }

    if (authInput.isEmpty) {
      CustomAlertDialog.alertDialogTitle(AlertMessages.failedSignIn, 'Please enter your password');              
      return;
    }

    await _loginUser(
      email: emailInput, 
      auth: authInput, 
    );
    
  }

  Widget _buildRememberMeCheckBox() {
    return CheckboxTheme(
      data: CheckboxThemeData(
        fillColor: MaterialStateColor.resolveWith(
          (states) => ThemeColor.contentThird,
        ),
        checkColor: MaterialStateColor.resolveWith(
          (states) => ThemeColor.contentSecondary,
        ),
        overlayColor: MaterialStateColor.resolveWith(
          (states) => ThemeColor.contentSecondary.withOpacity(0.1),
        ),
        side: BorderSide(
          color: ThemeColor.contentThird,
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
                checkColor: Colors.white,
                onChanged: (checkedValue) {
                  isRememberMeCheckedNotifier.value = checkedValue ?? true;
                },
              );
            },
          ),

          Text(
            'Remember Me',
            style: GoogleFonts.inter(
              color: ThemeColor.contentSecondary,
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
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.emailAddress,
            inputFormatters: InputFormatters.noSpaces(),
            controller: authController.emailController
          ),

          const SizedBox(height: 15),

          PasswordTextField(
            hintText: 'Enter your password',
            controller: authController.passwordController, 
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