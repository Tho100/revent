import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/themes/theme_color.dart';

class EmptyPage {

  Widget customMessage({required String message}) {
    return Center(
      child: Text(
        message,
        style: GoogleFonts.inter(
          color: ThemeColor.white,
          fontWeight: FontWeight.w800,
          fontSize: 15
        ),
      ),
    );
  }

}