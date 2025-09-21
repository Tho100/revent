import 'package:flutter/material.dart';
import 'package:revent/controllers/auth_controller.dart';
import 'package:revent/global/alert_messages.dart';
import 'package:revent/global/validation_limits.dart';
import 'package:revent/pages/authentication/sign_up_username.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/helper/input_formatters.dart';
import 'package:revent/helper/input_validator.dart';
import 'package:revent/shared/widgets/ui_dialog/alert_dialog.dart';
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

class _SignUpPageState extends State<SignUpPage> with AuthController {

  final isContinueButtonEnabledNotifier = ValueNotifier<bool>(false);

  void _checkFormFilled() {

    final isFilled = 
      emailController.text.trim().isNotEmpty &&
      passwordController.text.trim().isNotEmpty;

    final isValid = InputValidator.validateEmailFormat(emailController.text);

    final shouldEnable = isFilled && isValid;

    if (shouldEnable != isContinueButtonEnabledNotifier.value) {
      isContinueButtonEnabledNotifier.value = shouldEnable;
    }
    
  }

  Future<void> _proceedToUsernameRegistration({
    required String email,
    required String password,
  }) async {

    try {
      
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => SignUpUsernamePage(
            email: email, password: password
          ),
          transitionDuration: const Duration(milliseconds: 600),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {

            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.ease;

            final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );

          },
        ),
      );

    } catch (_) {
      
      if (context.mounted) {
        Navigator.pop(context);
      }

      SnackBarDialog.errorSnack(message: AlertMessages.defaultError);

    }
    
  }

  Future<void> _processRegistration() async {

    final emailInput = emailController.text;
    final passwordInput = passwordController.text;

    if (passwordInput.length < ValidationLimits.minPasswordLength) {
      CustomAlertDialog.alertDialogTitle(AlertMessages.failedSignUpTitle, AlertMessages.invalidPasswordLength);
      return;
    }

    if (!InputValidator.validateEmailFormat(emailInput)) {
      CustomAlertDialog.alertDialogTitle(AlertMessages.failedSignUpTitle, AlertMessages.invalidEmailAddr);
      return;
    }

    await _proceedToUsernameRegistration(
      email: emailInput, 
      password: passwordInput, 
    );
      
  }

  Widget _buildBody() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.sizeOf(context).width * 0.05,
        vertical: MediaQuery.sizeOf(context).height * 0.05,
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
            hintText: 'Enter your email address', 
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.emailAddress,
            inputFormatters: InputFormatters.noSpaces(),
            controller: emailController,
          ),

          const SizedBox(height: 15),

          PasswordTextField(
            hintText: 'Enter a password',
            controller: passwordController, 
          ),

          const SizedBox(height: 30),

          ValueListenableBuilder(
            valueListenable: isContinueButtonEnabledNotifier,
            builder: (_, isEnabled, __) {
              return MainButton(
                enabled: isEnabled,
                text: 'Continue',
                customFontSize: 17,
                onPressed: () async { 
                  FocusScope.of(context).unfocus(); 
                  await _processRegistration();
                },
              );
            },
          ),

          const Spacer(),

          const UnderlinedButton(
            text: 'Already have an account?', 
            onPressed: NavigatePage.signInPage
          ),
    
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    emailController.addListener(_checkFormFilled);
    passwordController.addListener(_checkFormFilled);
  }

  @override
  void dispose() {
    disposeControllers();
    isContinueButtonEnabledNotifier.dispose();
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