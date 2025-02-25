import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/widgets/bottomsheet/bottomsheet_widgets/bottomsheet.dart';
import 'package:revent/shared/widgets/bottomsheet/bottomsheet_widgets/bottomsheet_bar.dart';
import 'package:revent/shared/widgets/bottomsheet/bottomsheet_widgets/bottomsheet_title.dart';

class BottomsheetTagsSelection {
 
  Future buildBottomsheet({
    required BuildContext context
  }) {
    return Bottomsheet().buildBottomSheet(
      context: context, 
      children: [

        const SizedBox(height: 12),

        const BottomsheetBar(),

        const BottomsheetTitle(title: 'Tags'),

        Align(
          child: Padding(
            padding: const EdgeInsets.only(top: 6, bottom: 8),
            child: Text(
              'Add up to 3 tags',
              style: GoogleFonts.inter(
                color: ThemeColor.thirdWhite,
                fontSize: 14,
                fontWeight: FontWeight.w800
              ),
            ),
          ),
        ),

        const SizedBox(height: 35),

      ]
    );
  }

}