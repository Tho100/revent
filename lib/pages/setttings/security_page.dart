import 'package:flutter/material.dart';
import 'package:revent/themes/theme_color.dart';
import 'package:revent/widgets/app_bar.dart';
import 'package:revent/widgets/buttons/settings_button.dart';

class SecurityPage extends StatelessWidget {

  const SecurityPage({super.key});

  Widget _buildBody() {

    const buttonHeightGap = 8.0;

    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Column(
        children: [

          SettingsButton(
            text: 'Change password', 
            onPressed: () {}
          ),

          const SizedBox(height: buttonHeightGap),

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
            onPressed: () {}
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
      body: _buildBody(),
    );
  }

}