import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/themes/theme_color.dart';
import 'package:revent/widgets/buttons/custom_outlined_button.dart';
import 'package:revent/widgets/buttons/main_button.dart';

class MainScreenPage extends StatelessWidget {

  const MainScreenPage({super.key});

  Widget _buildButtons() {
    return Column(
      children: [

        const SizedBox(height: 30),

        MainButton(
          text: 'Sign In',
          customFontSize: 17,
          onPressed: () => NavigatePage.signInPage(),
        ),

        const SizedBox(height: 15),

        CustomOutlinedButton(
          text: 'Create an account',
          onPressed: () => NavigatePage.signUpPage(),
        ),

      ],
    );
  }

  Widget _buildLogoText() {
    return Text(
      ">:(",
      style: GoogleFonts.inter(
        color: ThemeColor.white,
        fontSize: 22,
        fontWeight: FontWeight.w900,
      ),
      textAlign: TextAlign.left,
    );
  }

  Widget _buildHeaderText() {
    return Text(
      "Read & Vent.",
      style: GoogleFonts.inter(
        color: ThemeColor.white,
        fontSize: 42,
        fontWeight: FontWeight.w900,
      ),
      textAlign: TextAlign.left,
    );
  }

  Widget _buildSubText() {
    return Text(
      "Share your thoughts, stories, and more!",
      style: GoogleFonts.inter(
        color: ThemeColor.thirdWhite,
        fontSize: 16,
        fontWeight: FontWeight.w800,
      ),
      textAlign: TextAlign.left,
    );
  }

  Widget _buildBottomContainer(BuildContext context) {
    return Container(
      color: ThemeColor.black,
      width: MediaQuery.of(context).size.width,
      height: 205,
      child: _buildButtons(),
    );
  }

  Widget _buildPaddedWidget({required Widget child}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: child
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        const SizedBox(height: 85),
        
        _buildPaddedWidget(
          child: _buildLogoText()
        ),
        
        const SizedBox(height: 18),

        _buildPaddedWidget(
          child: _buildHeaderText()
        ),
        
        const SizedBox(height: 12),

        _buildPaddedWidget(
          child: _buildSubText()
        ),
      
        const Spacer(),
        
        _buildBottomContainer(context)

      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context)
    );
  }
  
}