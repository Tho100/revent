import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/themes/theme_color.dart';
import 'package:revent/widgets/main_button.dart';

class MainScreenPage extends StatelessWidget {

  const MainScreenPage({Key? key}) : super(key: key);

  Widget buildButtons(BuildContext context) {
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
          width: MediaQuery.of(context).size.width-50,
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
            onPressed: () => NavigatePage.homePage(context),
            child: Text(
              "Create an account",
              style: GoogleFonts.inter(
                color: ThemeColor.secondaryWhite,
                fontWeight: FontWeight.w800,
                fontSize: 17,
              )
            ),
          ),
        ),

      ],
    );
  }

  Widget buildHeaderText() {
    return Text("Read & Vent.",
      style: GoogleFonts.inter(
        color: ThemeColor.white,
        fontSize: 42,
        fontWeight: FontWeight.w900,
      ),
      textAlign: TextAlign.left,
    );
  }

  Widget buildSubText() {
    return Text("Share your thoughts, stories, and more!",
      style: GoogleFonts.inter(
        color: ThemeColor.thirdWhite,
        fontSize: 16,
        fontWeight: FontWeight.w800,
      ),
      textAlign: TextAlign.left,
    );
  }

  Widget buildBottomContainer(BuildContext context) {
    return Container(
      color: ThemeColor.black,
      width: MediaQuery.of(context).size.width,
      height: 205,
      child: buildButtons(context),
    );
  }

  Widget buildBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        const SizedBox(height: 115),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: buildHeaderText(),
        ),
        
        const SizedBox(height: 12),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: buildSubText(),
        ),
      
        const Spacer(),
        buildBottomContainer(context)

      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildBody(context)
    );
  }
  
}