import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:revent/global/alert_messages.dart';
import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/main.dart';
import 'package:revent/pages/archive/archived_vent_page.dart';
import 'package:revent/pages/setttings/blocked_accounts_page.dart';
import 'package:revent/pages/setttings/account_info_page.dart';
import 'package:revent/pages/setttings/app_info_page.dart';
import 'package:revent/pages/setttings/privacy_page.dart';
import 'package:revent/pages/setttings/saved_page.dart';
import 'package:revent/pages/setttings/security_page.dart';
import 'package:revent/pages/setttings/liked_page.dart';
import 'package:revent/pages/setttings/theme_page.dart';
import 'package:revent/pages/setttings/vent_plus_page.dart';
import 'package:revent/service/user/user_account_manager.dart';
import 'package:revent/shared/widgets/boredered_container.dart';
import 'package:revent/shared/widgets/ui_dialog/alert_dialog.dart';
import 'package:revent/shared/widgets/app_bar.dart';
import 'package:revent/shared/widgets/buttons/settings_button.dart';

class SettingsPage extends StatelessWidget {

  const SettingsPage({super.key});

  Future<void> _onConfirmSignOutPressed() async {
    await UserAccountManager().signOutUserAccount().then(
      (_) => NavigatePage.mainScreenPage()
    );
  }

  void _clearLikedAndSavedData() {
    getIt.likedVentProvider.clearVents();
    getIt.savedVentProvider.clearVents();
  }

  void _navigateToPage({
    required BuildContext context,
    required Widget classPage
  }) {
    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (_) => classPage
      )
    );
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
                  text: 'Account Information', 
                  icon: CupertinoIcons.person,
                  onPressed: () => _navigateToPage(
                    context: context, 
                    classPage: const AccountInformationPage()
                  )
                ),
                  
                const SizedBox(height: buttonGap),
                
                SettingsButton(
                  text: 'Privacy', 
                  icon: CupertinoIcons.lock,
                  onPressed: () => _navigateToPage(
                    context: context, 
                    classPage: const PrivacyPage()
                  )
                ),
                  
                const SizedBox(height: buttonGap),
                
                SettingsButton(
                  text: 'Security', 
                  icon: CupertinoIcons.shield,
                  onPressed: () => _navigateToPage(
                    context: context, 
                    classPage: const SecurityPage()
                  )
                ),
          
                const SizedBox(height: buttonGap),
                
                SettingsButton(
                  text: 'Blocked', 
                  icon: CupertinoIcons.clear_circled,
                  onPressed: () => _navigateToPage(
                    context: context, 
                    classPage: const BlockedAccountsPage()
                  )
                ),
          
                const SizedBox(height: buttonGap),
          
                SettingsButton(
                  text: 'Liked', 
                  icon: CupertinoIcons.heart,
                  onPressed: () => _navigateToPage(
                    context: context, 
                    classPage: const LikedPage()
                  )
                ),
                  
                const SizedBox(height: buttonGap),
                
                SettingsButton(
                  text: 'Saved', 
                  icon: CupertinoIcons.bookmark,
                  onPressed: () => _navigateToPage(
                    context: context, 
                    classPage: const SavedPage()
                  )
                ),
          
                const SizedBox(height: buttonGap),
                
                SettingsButton(
                  text: 'Archive', 
                  icon: CupertinoIcons.archivebox,
                  onPressed: () => _navigateToPage(
                    context: context, 
                    classPage: const ArchivedVentPage()
                  )
                ),
          
                const SizedBox(height: buttonGap),
                
                SettingsButton(
                  text: 'Theme', 
                  icon: CupertinoIcons.paintbrush,
                  onPressed: () => _navigateToPage(
                    context: context, 
                    classPage: const ThemePage()
                  )
                ),

                const SizedBox(height: buttonGap),
          
                SettingsButton(
                  text: 'Get Vent+', 
                  icon: CupertinoIcons.sparkles,
                  onPressed: () => _navigateToPage(
                    context: context, 
                    classPage: const VentPlusPage()
                  )
                ),

                const SizedBox(height: buttonGap),
          
                SettingsButton(
                  text: 'Info', 
                  icon: CupertinoIcons.info,
                  onPressed: () => _navigateToPage(
                    context: context, 
                    classPage: const AppInfoPage()
                  )
                ),

              ],
            ),
          ),

          BorderedContainer(
            child: SettingsButton(
              text: 'Sign Out', 
              icon: CupertinoIcons.square_arrow_right,
              makeRed: true,
              hideCaret: true,
              onPressed: () {
                CustomAlertDialog.alertDialogCustomOnPress(
                  message: AlertMessages.signOut, 
                  buttonMessage: 'Sign Out', 
                  onPressedEvent: () async => await _onConfirmSignOutPressed()
                );
              }
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
          title: 'Settings & Activity',
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