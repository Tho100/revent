import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:revent/global/alert_messages.dart';
import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/main.dart';
import 'package:revent/model/user/user_account_manager.dart';
import 'package:revent/pages/archive/archived_vent_page.dart';
import 'package:revent/pages/setttings/blocked_accounts_page.dart';
import 'package:revent/pages/setttings/account_info_page.dart';
import 'package:revent/pages/setttings/app_info_page.dart';
import 'package:revent/pages/setttings/privacy_page.dart';
import 'package:revent/pages/setttings/saved_page.dart';
import 'package:revent/pages/setttings/security_page.dart';
import 'package:revent/pages/setttings/liked_page.dart';
import 'package:revent/shared/widgets/boredered_container.dart';
import 'package:revent/shared/widgets/ui_dialog/alert_dialog.dart';
import 'package:revent/shared/widgets/app_bar.dart';
import 'package:revent/shared/widgets/buttons/settings_button.dart';

class SettingsPage extends StatelessWidget {

  const SettingsPage({super.key});

  void _signOutOnPressed() {
    CustomAlertDialog.alertDialogCustomOnPress(
      message: AlertMessages.signOut, 
      buttonMessage: 'Sign out', 
      onPressedEvent: () async {
        await UserAccountManager().signOutUserAccount().then(
          (_) => NavigatePage.mainScreenPage()
        );
      }
    );
  }

  void _clearLikedAndSavedData() {
    getIt.likedVentProvider.clearVents();
    getIt.savedVentProvider.clearVents();
  }

  Widget _buildBody(BuildContext context) {

    const buttonGap = 14.0;

    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Column(
        children: [
                    
          BorderedContainer(
            doubleInternalPadding: true,
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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const BlockedAccountsPage())
                    );
                  }
                ),
          
                const SizedBox(height: buttonGap),
          
                SettingsButton(
                  text: 'Liked', 
                  icon: CupertinoIcons.heart,
                  onPressed: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (_) => const LikedPage())
                    );
                  }
                ),
                  
                const SizedBox(height: buttonGap),
                
                SettingsButton(
                  text: 'Saved', 
                  icon: CupertinoIcons.bookmark,
                  onPressed: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (_) => const SavedPage())
                    );
                  }
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
              ],
            ),
          ),

          BorderedContainer(
            child: SettingsButton(
              text: 'Sign out', 
              icon: CupertinoIcons.square_arrow_right,
              makeRed: true,
              hideCaret: true,
              onPressed: () => _signOutOnPressed()
            ),
          ),
          
        ]
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _clearLikedAndSavedData();
        return true;
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Settings and activity',
          context: context,
          customBackOnPressed: () {
            _clearLikedAndSavedData();
            Navigator.pop(context);
          }
        ).buildAppBar(),
        body: _buildBody(context),
      ),
    );
  }

}