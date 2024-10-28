import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/model/local_storage_model.dart';
import 'package:revent/pages/setttings/account/account_information.dart';
import 'package:revent/provider/profile_data_provider.dart';
import 'package:revent/provider/user_data_provider.dart';
import 'package:revent/themes/theme_color.dart';
import 'package:revent/ui_dialog/alert_dialog.dart';
import 'package:revent/widgets/app_bar.dart';
import 'package:revent/widgets/buttons/settings_button.dart';

class SettingsPage extends StatelessWidget {

  const SettingsPage({super.key});

  void _signOutOnPressed() async {

    final userData = GetIt.instance<UserDataProvider>();
    final profileData = GetIt.instance<ProfileDataProvider>();

    userData.clearUserData();
    profileData.clearProfileData();

    await LocalStorageModel().deleteLocalData();

    NavigatePage.mainScreenPage();

  }

  Widget _buildHeader(IconData icon, String message) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16, 
        vertical: 8
      ),
      child: Row(
        children: [
    
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Icon(icon, color: ThemeColor.thirdWhite, size: 24),
          ),

          const SizedBox(width: 8),

          Text(
            message,
            style: GoogleFonts.inter(
              color: ThemeColor.thirdWhite,
              fontWeight: FontWeight.w700,
              fontSize: 15
            ),
          )
          
        ]
      ),
    );
  }

  Widget _buildBody(BuildContext context) {

    const buttonHeightGap = 8.0;

    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.87,
          child: Column(
            children: [
            
              _buildHeader(CupertinoIcons.profile_circled, 'Account'),
            
              SettingsButton(
                text: 'Account information', 
                onPressed: () {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (_) => const AccountInformationPage())
                  );
                }
              ),
            
              const SizedBox(height: buttonHeightGap),
              
              SettingsButton(
                text: 'Privacy', 
                onPressed: () {}
              ),
            
              const SizedBox(height: buttonHeightGap),
              
              SettingsButton(
                text: 'Blocked', 
                onPressed: () {}
              ),

              const Spacer(),
        
              Padding(
                padding: const EdgeInsets.only(bottom: 18.0),
                child: SettingsButton(
                  text: 'Sign out', 
                  isSignOutButton: true,
                  onPressed: () => CustomAlertDialog.alertDialogCustomOnPress(
                    message: 'Are you sure you want to sign out of your account?', 
                    buttonMessage: 'Sign out', 
                    onPressedEvent: () async => _signOutOnPressed()
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  'v1.0.0',
                  style: GoogleFonts.inter(
                    color: ThemeColor.secondaryWhite,
                    fontWeight: FontWeight.w800,
                    fontSize: 13
                  ),
                ),
              )
              
            ]
          ),
        )
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