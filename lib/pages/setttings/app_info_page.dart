import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/themes/theme_color.dart';
import 'package:revent/widgets/app_bar.dart';
import 'package:revent/widgets/buttons/main_button.dart';
import 'package:revent/widgets/buttons/settings_button.dart';

class AppInfoPage extends StatefulWidget {

  const AppInfoPage({super.key});

  @override
  State<AppInfoPage> createState() => AppInfoPageState();

}

class AppInfoPageState extends State<AppInfoPage> {

  Widget _buildHeaders(String header, String value) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          Text(
            header,
            style: GoogleFonts.inter(
              color: ThemeColor.thirdWhite,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
    
          const SizedBox(height: 8),
    
          Text(
            value,
            style: GoogleFonts.inter(
              color: ThemeColor.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
    
          const SizedBox(height: 20),
    
        ],
      ),
    );
  }

  Widget _buildClearCacheButton() {
    return MainButton(
      customWidth: MediaQuery.of(context).size.width * 0.26,
      customHeight: 46,
      text: 'Clear cache', 
      onPressed: () => print('Cleared')
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.only(top: 0.0), // TODO: Remove unused padding
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const SizedBox(height: 12),

          Padding(
            padding: const EdgeInsets.only(left: 14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                _buildHeaders('Version', '1.0.0'),
                _buildHeaders('Cache', '0.4Mb'),
                    
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    "You can free up storage by clearing cache. Your data won't be affected.",
                    style: GoogleFonts.inter(
                      color: ThemeColor.thirdWhite,
                      fontWeight: FontWeight.w800,
                      fontSize: 14
                    ),
                  ),
                ),
          
                const SizedBox(height: 15),

                _buildClearCacheButton(),

              ],
            ),
          ),
          
          const SizedBox(height: 15),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.0),
            child: Divider(color: ThemeColor.lightGrey),
          ),

          const SizedBox(height: 8),

          SettingsButton(
            text: 'Term and Conditions', 
            onPressed: () {}
          ),

          const SizedBox(height: 8),

          SettingsButton(
            text: 'Privacy Policy', 
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
        title: 'Info'
      ).buildAppBar(),
      body: _buildBody(),
    );
  }
}