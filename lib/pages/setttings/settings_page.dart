import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/pages/setttings/account/account_information.dart';
import 'package:revent/themes/theme_color.dart';
import 'package:revent/widgets/app_bar.dart';
import 'package:revent/widgets/buttons/settings_button.dart';

class SettingsPage extends StatelessWidget {

  const SettingsPage({super.key});

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
        child: Column(
          children: [
    
            _buildHeader(CupertinoIcons.profile_circled, 'Account'),
    
            SettingsButton(
              text: 'Account information', 
              onPressed: () {
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (_) => AccountInformationPage())
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
      
            const SizedBox(height: 3030)

          ]
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