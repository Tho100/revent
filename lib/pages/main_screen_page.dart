import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/themes/theme_color.dart';
import 'package:revent/widgets/main_button.dart';

class MainScreenPage extends StatelessWidget {

  const MainScreenPage({super.key});

  Widget _buildButtons(BuildContext context) {
    return Column(
      children: [

        const SizedBox(height: 30),

        MainButton(
          text: "Sign In",
          onPressed: () => NavigatePage.homePage(context),
        ),

        const SizedBox(height: 15),

        SizedBox(
          height: 68,
          width: MediaQuery.of(context).size.width * 0.87,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: ThemeColor.thirdWhite,
              backgroundColor: ThemeColor.black,
              side: const BorderSide(
                color: ThemeColor.white,
                width: 1.5
              ),
              shape: const StadiumBorder(),
            ),
            onPressed: () => NavigatePage.signUpPage(context),
            child: Text(
              "Create an account",
              style: GoogleFonts.inter(
                color: ThemeColor.white,
                fontWeight: FontWeight.w800,
                fontSize: 17,
              )
            ),
          ),
        ),

      ],
    );
  }

  Widget _buildLogoText() {
    return Text(">:(",
      style: GoogleFonts.inter(
        color: ThemeColor.white,
        fontSize: 22,
        fontWeight: FontWeight.w900,
      ),
      textAlign: TextAlign.left,
    );
  }

  Widget _buildHeaderText() {
    return Text("Read & Vent.",
      style: GoogleFonts.inter(
        color: ThemeColor.white,
        fontSize: 42,
        fontWeight: FontWeight.w900,
      ),
      textAlign: TextAlign.left,
    );
  }

  Widget _buildSubText() {
    return Text("Share your thoughts, stories, and more!",
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
      child: _buildButtons(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        const SizedBox(height: 85),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: _buildLogoText(),
        ),

        const SizedBox(height: 18),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: _buildHeaderText(),
        ),
        
        const SizedBox(height: 12),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: _buildSubText(),
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