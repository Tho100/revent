import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:revent/model/user_model.dart';
import 'package:revent/pages/archive/archived_vent_page.dart';
import 'package:revent/pages/setttings/account_info_page.dart';
import 'package:revent/pages/setttings/app_info_page.dart';
import 'package:revent/pages/setttings/privacy_page.dart';
import 'package:revent/pages/setttings/security_page.dart';
import 'package:revent/themes/theme_color.dart';
import 'package:revent/ui_dialog/alert_dialog.dart';
import 'package:revent/widgets/app_bar.dart';
import 'package:revent/widgets/buttons/settings_button.dart';

class SettingsPage extends StatelessWidget {

  const SettingsPage({super.key});

  void _signOutOnPressed() {
    CustomAlertDialog.alertDialogCustomOnPress(
      message: 'Sign out of your account?', 
      buttonMessage: 'Sign out', 
      onPressedEvent: () => UserModel().signOutUser()
    );
  }

  Widget _buildBody(BuildContext context) {

    const buttonGap = 14.0;

    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Column(
        children: [
                    
          SettingsButton(
            text: 'Account information', 
            icon: CupertinoIcons.person,
            onPressed: () {
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (_) => const AccountInformationPage())
              );
            }
          ),
        
          const SizedBox(height: buttonGap),
          
          SettingsButton(
            text: 'Privacy', 
            icon: CupertinoIcons.lock,
            onPressed: () {
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (_) => const PrivacyPage())
              );
            }
          ),
        
          const SizedBox(height: buttonGap),
          
          SettingsButton(
            text: 'Security', 
            icon: CupertinoIcons.shield,
            onPressed: () {
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (_) => const SecurityPage())
              );
            }
          ),

          const SizedBox(height: buttonGap),
          
          SettingsButton(
            text: 'Blocked', 
            icon: CupertinoIcons.clear_circled,
            onPressed: () {}
          ),

          const SizedBox(height: buttonGap),

          SettingsButton(
            text: 'Liked', 
            icon: CupertinoIcons.heart,
            onPressed: () {}
          ),
        
          const SizedBox(height: buttonGap),
          
          SettingsButton(
            text: 'Saved', 
            icon: CupertinoIcons.bookmark,
            onPressed: () {}
          ),

          const SizedBox(height: buttonGap),
          
          SettingsButton(
            text: 'Archive', 
            icon: CupertinoIcons.archivebox,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ArchivedVentPage())
              );
            }
          ),

          const SizedBox(height: buttonGap),

          SettingsButton(
            text: 'Info', 
            icon: CupertinoIcons.info,
            onPressed: () {
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (_) => const AppInfoPage())
              );
            }
          ),

          const SizedBox(height: 16),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.0),
            child: Divider(color: ThemeColor.lightGrey),
          ),

          const SizedBox(height: 8),

          SettingsButton(
            text: 'Sign out', 
            makeRed: true,
            onPressed: () => _signOutOnPressed()
          ),
          
        ]
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Settings',
        context: context
      ).buildAppBar(),
      body: _buildBody(context),
    );
  }

}