import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/global/alert_messages.dart';
import 'package:revent/shared/provider_mixins.dart';
import 'package:revent/controllers/security_auth_controller.dart';
import 'package:revent/service/query/user/user_auth_service.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/themes/theme_style.dart';
import 'package:revent/shared/widgets/ui_dialog/alert_dialog.dart';
import 'package:revent/shared/widgets/ui_dialog/snack_bar.dart';
import 'package:revent/shared/widgets/app_bar.dart';
import 'package:revent/shared/widgets/buttons/main_button.dart';
import 'package:revent/shared/widgets/text/header_text.dart';
import 'package:revent/shared/widgets/text_field/password_textfield.dart';

class ChangePasswordPage extends StatefulWidget {

  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();

}

class _ChangePasswordPageState extends State<ChangePasswordPage> with 
  UserProfileProviderService,
  SecurityAuthController {

  final isContinueButtonEnabledNotifier = ValueNotifier<bool>(false);

  void _checkFormFilled() {

    final isFilled = 
      currentPasswordController.text.trim().isNotEmpty &&
      newPasswordController.text.trim().isNotEmpty;

    final shouldEnable = isFilled && newPasswordController.text.length >= 6;

    if (isFilled != isContinueButtonEnabledNotifier.value) {
      isContinueButtonEnabledNotifier.value = shouldEnable;
    }
    
  }

  Future<void> _onUpdatePasswordPressed() async {

    try {

      final currentPasswordInput = currentPasswordController.text.trim();
      final newPasswordInput = newPasswordController.text.trim();

      if (newPasswordInput.isEmpty || currentPasswordInput.isEmpty) {
        CustomAlertDialog.alertDialog(AlertMessages.emptyPasswordFields);
        return;
      }

      if (newPasswordInput == currentPasswordInput) {
        CustomAlertDialog.alertDialog(AlertMessages.matchingPasswordFields);
        return;
      }

      final verifyAuthResponse = await UserAuthService.verifyUserAuth(
        username: userProvider.user.username, password: currentPasswordInput
      );

      if (verifyAuthResponse['status_code'] == 401) {
        CustomAlertDialog.alertDialog(AlertMessages.incorrectPassword);
        return;
      }

      await UserAuthService.updateAccountAuth(
        username: userProvider.user.username, 
        newPassword: newPasswordInput
      ).then(
        (_) => CustomAlertDialog.alertDialogTitle(
          AlertMessages.passwordUpdatedTitle, AlertMessages.passwordHasBeenUpdated
        )
      );

    } catch (_) {
      SnackBarDialog.errorSnack(message: AlertMessages.defaultError);
    }
    
  }

  Widget _passwordRequirementBullet(String requirement) {
    return Row(
      children: [

        ValueListenableBuilder(
          valueListenable: isContinueButtonEnabledNotifier,
          builder: (_, isEnabled, __) {
            return isEnabled 
              ? Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Icon(CupertinoIcons.check_mark, color: ThemeColor.contentPrimary, size: 14)
                ) 
              : Text(
                ThemeStyle.dotSeparator,
                style: GoogleFonts.inter(
                  color: ThemeColor.contentThird,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              );
          }
        ),
        
        Text(
          requirement,
          style: GoogleFonts.inter(
            color: ThemeColor.contentSecondary,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        )

      ],
    );
  }

  Widget _passwordRequirements() {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, top: 16.0),
      child: Column(
        children: [
    
          _passwordRequirementBullet('6 characters minimum')
    
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.sizeOf(context).width * 0.05,
      ),
      child: Column(
        children: [
  
          const Padding(
            padding: EdgeInsets.only(left: 4.0),
            child: HeaderText(
              title: 'Update Password', // TODO: Update to 'chnage'
              subTitle: ''
            ),
          ),
          
          const SizedBox(height: 10),

          PasswordTextField(
            hintText: 'Enter your current password',
            controller: currentPasswordController, 
          ),

          const SizedBox(height: 15),

          PasswordTextField(
            hintText: 'Enter a new password',
            controller: newPasswordController, 
          ),

          const SizedBox(height: 8),

          _passwordRequirements(),

          const SizedBox(height: 30),

          ValueListenableBuilder(
            valueListenable: isContinueButtonEnabledNotifier,
            builder: (_, isEnabled, __) {
              return MainButton(
                enabled: isEnabled,
                text: 'Update',
                customFontSize: 17,
                onPressed: () async {
                  FocusScope.of(context).unfocus(); 
                  await _onUpdatePasswordPressed();
                }
              );
            }
          ),
    
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    currentPasswordController.addListener(_checkFormFilled);
    newPasswordController.addListener(_checkFormFilled);
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
      appBar: CustomAppBar(
        context: context, 
      ).buildAppBar(),
      resizeToAvoidBottomInset: false,
      body: _buildBody(),
    );
  }
  
}