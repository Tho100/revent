import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/shared/themes/theme_color.dart';

class EmptyPage {

  Widget customMessage({required String message}) {
    return Center(
      child: Text(
        message,
        style: GoogleFonts.inter(
          color: ThemeColor.secondaryWhite,
          fontWeight: FontWeight.w800,
          fontSize: 15
        ),
      ),
    );
  }

  Widget headerCustomMessage({
    required String header, 
    required String subheader
  }) {
    return Center(
      child: Column(
        children: [

          Text(
            header,
            style: GoogleFonts.inter(
              color: ThemeColor.white,
              fontWeight: FontWeight.w800,
              fontSize: 17
            ),
          ),

          const SizedBox(height: 6),

          Text(
            subheader,
            style: GoogleFonts.inter(
              color: ThemeColor.thirdWhite,
              fontWeight: FontWeight.w800,
              fontSize: 15
            ),
            textAlign: TextAlign.center
          ),

        ],
      ),
    );
  }

}