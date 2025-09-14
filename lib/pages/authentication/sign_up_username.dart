import 'package:flutter/material.dart';
import 'package:revent/controllers/auth_controller.dart';
import 'package:revent/global/alert_messages.dart';
import 'package:revent/service/user/user_registration_service.dart';
import 'package:revent/helper/input_formatters.dart';
import 'package:revent/helper/input_validator.dart';
import 'package:revent/shared/widgets/ui_dialog/alert_dialog.dart';
import 'package:revent/shared/widgets/ui_dialog/loading/spinner_loading.dart';
import 'package:revent/shared/widgets/ui_dialog/snack_bar.dart';
import 'package:revent/shared/widgets/text/header_text.dart';
import 'package:revent/shared/widgets/buttons/main_button.dart';
import 'package:revent/shared/widgets/text_field/main_textfield.dart';

class SignUpUsernamePage extends StatefulWidget {

  final String email;
  final String password;

  const SignUpUsernamePage({
    required this.email, 
    required this.password, 
    super.key
  });

  @override
  State<SignUpUsernamePage> createState() => _SignUpUsernamePageState();

}

class _SignUpUsernamePageState extends State<SignUpUsernamePage> with AuthController {

  final isSignUpButtonEnabledNotifier = ValueNotifier<bool>(false);

  void _checkFormFilled() {

    final isFilled = usernameController.text.trim().isNotEmpty;

    final isValid = InputValidator.validateUsernameFormat(usernameController.text);

    final shouldEnable = isFilled && isValid;

    if (shouldEnable != isSignUpButtonEnabledNotifier.value) {
      isSignUpButtonEnabledNotifier.value = shouldEnable;
    }
    
  }

  Future<void> _registerUser() async {

    try {
      
      await UserRegistrationService(context: context).register(
        username: usernameController.text,
        password: widget.password,
        email: widget.email,
      );

    } catch (_) {
      
      if (context.mounted) {
        Navigator.pop(context);
      }

      SnackBarDialog.errorSnack(message: AlertMessages.defaultError);

    }
    
  }

  Future<void> _processRegistration() async {

    final usernameInput = usernameController.text;

    if (!InputValidator.validateUsernameFormat(usernameInput)) {
      CustomAlertDialog.alertDialogTitle(AlertMessages.failedSignUpTitle, AlertMessages.invalidUsername);
      return;
    }

    SpinnerLoading(context: context).startLoading();

    await _registerUser();
      
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
              title: 'Almost there...', 
              subTitle: 'Create a username for your profile'
            ),
          ),
          
          const SizedBox(height: 30),

          MainTextField(
            hintText: 'Enter a username', 
            maxLength: 24,
            autoFocus: true,
            textInputAction: TextInputAction.next,
            inputFormatters: InputFormatters.usernameFormatter(),
            controller: usernameController,
          ),

          const SizedBox(height: 30),

          ValueListenableBuilder(
            valueListenable: isSignUpButtonEnabledNotifier,
            builder: (_, isEnabled, __) {
              return MainButton(
                enabled: isEnabled,
                text: 'Sign Up',
                customFontSize: 17,
                onPressed: () async { 
                  FocusScope.of(context).unfocus(); 
                  await _processRegistration();
                },
              );
            },
          ),

        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    usernameController.addListener(_checkFormFilled);
  }

  @override
  void dispose() {
    disposeControllers();
    isSignUpButtonEnabledNotifier.dispose();
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