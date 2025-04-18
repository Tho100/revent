import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/widgets/bottomsheet/bottomsheet_widgets/bottomsheet.dart';
import 'package:revent/shared/widgets/bottomsheet/bottomsheet_widgets/bottomsheet_bar.dart';
import 'package:revent/shared/widgets/bottomsheet/bottomsheet_widgets/bottomsheet_title.dart';

class BottomsheetViewFullBio {

  Future buildBottomsheet({
    required BuildContext context,
    required String bio,
  }) {
    return Bottomsheet().buildBottomSheet(
      context: context, 
      children: [

        const BottomsheetBar(),

        const BottomsheetTitle(title: 'Bio'),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: SelectableText(
            bio,
            style: GoogleFonts.inter(
              color: ThemeColor.white,
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