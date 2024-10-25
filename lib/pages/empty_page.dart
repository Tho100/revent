import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/themes/theme_color.dart';

class EmptyPage {

  Widget nothingToSeeHere() {
    return Column(
      children: [

        Text('¯\\_(ツ)_/¯',
          style: GoogleFonts.inter(
            color: ThemeColor.thirdWhite,
            fontWeight: FontWeight.w400,
            fontSize: 45
          ),
        ),

        const SizedBox(height: 12),

        Text('Nothing to see here',
          style: GoogleFonts.inter(
            color: ThemeColor.thirdWhite,
            fontWeight: FontWeight.w800,
            fontSize: 15
          ),
        ),

      ],
    );
  }

}