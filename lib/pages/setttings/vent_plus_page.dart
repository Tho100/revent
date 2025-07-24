import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/widgets/app_bar.dart';
import 'package:revent/shared/widgets/buttons/main_button.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class VentPlusPage extends StatelessWidget {

  const VentPlusPage({super.key});

  Widget _buildVentPlusHeader() {

    final headerColors = ThemeColor.backgroundPrimary == Colors.white 
      ? const [
        Colors.grey,
        Colors.black,
        Color.fromARGB(255, 85, 85, 85),
      ]
      : const [
        Color.fromARGB(255, 59, 59, 59),
        Color.fromARGB(255, 213, 213, 213),
        Color.fromARGB(255, 121, 121, 121),
      ];

    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Center(
        child: Column(
          children: [

            GradientText(
              'Unlock more features with',
                style: GoogleFonts.inter(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w800
                ),
                textAlign: TextAlign.center,
                colors: headerColors
            ),

            const SizedBox(height: 10),

            GradientText(
              'Vent+',
                style: GoogleFonts.inter(
                  fontSize: 60.0,
                  fontWeight: FontWeight.w800
                ),
                textAlign: TextAlign.center,
                colors: headerColors
            ),

          ],
        ),
      ),
    );
  }

  Widget _buildFeatures(IconData icon, String title, String subheader) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 170,
        height: 190,
        decoration: BoxDecoration(
          color: ThemeColor.backgroundPrimary,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: ThemeColor.contentPrimary)
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [

              const SizedBox(height: 15),

              Icon(icon, color: ThemeColor.contentPrimary, size: 27),

              const SizedBox(height: 20),
        
              Text(
                title,
                style: GoogleFonts.inter(
                  color: ThemeColor.contentPrimary,
                  fontWeight: FontWeight.w800,
                  fontSize: 18
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),
        
              Text(
                subheader,
                style: GoogleFonts.inter(
                  color: ThemeColor.contentThird,
                  fontWeight: FontWeight.w700,
                  fontSize: 13
                ),
                textAlign: TextAlign.center,
              ),

            ],
          ),
        )
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 15.0, right: 5.0, left: 5.0),
        child: Column(
          children: [
      
            _buildVentPlusHeader(),
    
            const SizedBox(height: 45),
    
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildFeatures(CupertinoIcons.check_mark_circled, 'Special Badge', 'Youre officialy vent+ member.'),
                _buildFeatures(CupertinoIcons.square_pencil, 'Longer Post', 'Make longer post with increased body text limit.'),
              ],
            ),
    
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildFeatures(Icons.trending_up_outlined, 'Post Analytics', 'View who likes and saved your posts.'),
                _buildFeatures(CupertinoIcons.paintbrush, 'Exclusive Themes', 'Get access to more themes.'),
              ],
            ),
    
          ],
        ),
      ),
    );
  }

  Widget _buildSubscribeBottomButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 18.0, right: 18.0, bottom: 28.0),
      child: MainButton(
        customFontSize: 16,
        text: 'RM21/mo', 
        onPressed: () {}
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context: context,
        title: 'Upgrade'
      ).buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: _buildSubscribeBottomButton(),
    );
  }

}