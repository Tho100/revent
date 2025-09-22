import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/widgets/buttons/custom_outlined_button.dart';
import 'package:revent/shared/widgets/buttons/main_button.dart';

class MainScreenPage extends StatelessWidget {

  const MainScreenPage({super.key});

  Widget _buildButtons() {
    return const Column(
      children: [

        SizedBox(height: 30),

        MainButton(
          text: 'Create Account',
          customFontSize: 17,
          onPressed: NavigatePage.signUpPage,
        ),

        SizedBox(height: 15),

        CustomOutlinedButton(
          text: 'Sign In',
          onPressed: NavigatePage.signInPage,
        ),

      ],
    );
  }

  Widget _buildLogo() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Image.asset(
        'assets/images/albert_icon.png',
        width: 100,
        height: 100,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildHeaderText() {
    return Text(
      'Read & Vent',
      style: GoogleFonts.inter(
        color: ThemeColor.contentPrimary,
        fontSize: 42,
        fontWeight: FontWeight.w900,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildSubText() {
    return Text(
      'A place to share your thoughts.',
      style: GoogleFonts.inter(
        color: ThemeColor.contentThird,
        fontSize: 16,
        fontWeight: FontWeight.w800,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildBottomContainer(BuildContext context) {
    return Container(
      color: ThemeColor.backgroundPrimary,
      width: MediaQuery.sizeOf(context).width,
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
      children: [

        const SizedBox(height: 10),
        
        const Spacer(),

        _buildPaddedWidget(
          child: _buildLogo()
        ),
        
        const SizedBox(height: 15),

        _buildPaddedWidget(
          child: _buildHeaderText()
        ),
        
        const SizedBox(height: 12),

        _buildPaddedWidget(
          child: _buildSubText()
        ),
      
        const Spacer(),
        
        _buildBottomContainer(context),

        const SizedBox(height: 45),
        
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