import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/widgets/bottomsheet/bottomsheet_widgets/bottomsheet.dart';
import 'package:revent/shared/widgets/bottomsheet/bottomsheet_widgets/bottomsheet_header.dart';

class BottomsheetViewFullBio {

  Future buildBottomsheet({
    required BuildContext context,
    required String bio,
  }) {
    return Bottomsheet().buildBottomSheet(
      context: context, 
      children: [

        const BottomsheetHeader(title: 'Bio'),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: SelectableText(
            bio,
            style: GoogleFonts.inter(
              color: ThemeColor.contentPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 16
            ),
          ),
        ),
        
        const SizedBox(height: 50),

      ]
    );
  }
  
}