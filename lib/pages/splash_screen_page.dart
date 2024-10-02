import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/themes/theme_color.dart';

class SplashScreen extends StatefulWidget {

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => SplashScreenState();

}

class SplashScreenState extends State<SplashScreen> {

  Timer? splashScreenTimer;

  Widget _buildSplashScreen() {
    return Container(
      color: ThemeColor.black,
      child: Align(
        alignment: Alignment.center,
        child: Center(
          child: Text(
            'Revent',
            style: GoogleFonts.inter(
              color: ThemeColor.white,
              fontWeight: FontWeight.w900,
              fontSize: 50
            )
          )
        )
      )
    );  
  }

  void _startTimer() {
    splashScreenTimer = Timer(const Duration(milliseconds: 2500), () {
      NavigatePage.homePage(context);
    });
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    splashScreenTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildSplashScreen()
    );
  }

}