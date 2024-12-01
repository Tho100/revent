import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/themes/theme_color.dart';
import 'package:revent/widgets/app_bar.dart';

class PrivacyPage extends StatefulWidget {

  const PrivacyPage({super.key});

  @override
  State<PrivacyPage> createState() => PrivacyPageState();

}

class PrivacyPageState extends State<PrivacyPage> {

  Widget _buildSwitch(String text, String description) {
    return Padding(
      padding: const EdgeInsets.only(left: 18.0, right: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [

              Text(
                text,
                style: GoogleFonts.inter(
                  color: ThemeColor.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 18
                ),
              ),

              const Spacer(),

              CupertinoSwitch(
                value: false,
                onChanged: (value) {
                  
                },
              ),

            ],
          ),

          SizedBox(
            width: 285,
            child: Text(
              description,
              style: GoogleFonts.inter(
                color: ThemeColor.thirdWhite,
                fontWeight: FontWeight.w700,
                fontSize: 12
              )
            ),
          ),

        ],
      ),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Column(
        children: [

          _buildSwitch(
            'Private account',
            "When your account is private, your profile posts, saved posts, following, and followers list can't be seen by other user."
          ),

          const SizedBox(height: 8),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.0),
            child: Divider(color: ThemeColor.lightGrey),
          ),

          const SizedBox(height: 8),

          _buildSwitch(
            'Hide saved post',
            'Only you can see your saved vent post when this option is enabled.'
          ),

          const SizedBox(height: 16),

          _buildSwitch(
            'Hide following list',
            'Only you can see your following list when this option is enabled.'
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
        title: 'Privacy'
      ).buildAppBar(),
      body: _buildBody(),
    );
  }
  
}