import 'package:flutter/material.dart';
import 'package:revent/pages/setttings/security/change_password_page.dart';
import 'package:revent/pages/setttings/security/deactivate_account_page.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/widgets/app_bar.dart';
import 'package:revent/shared/widgets/buttons/settings_button.dart';

class SecurityPage extends StatelessWidget {

  const SecurityPage({super.key});

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Column(
        children: [

          SettingsButton(
            text: 'Change password', 
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ChangePasswordPage())
              );
            }
          ),

          const SizedBox(height: 8),

          SettingsButton(
            text: 'Recovery key', 
            onPressed: () {}
          ),

          const SizedBox(height: 8),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.0),
            child: Divider(color: ThemeColor.lightGrey),
          ),
          
          const SizedBox(height: 8),

          SettingsButton(
            text: 'Delete account', 
            makeRed: true,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DeactivateAccountPage())
              );
            }
          ),

        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context: context, 
        title: 'Security'
      ).buildAppBar(),
      body: _buildBody(context),
    );
  }

}