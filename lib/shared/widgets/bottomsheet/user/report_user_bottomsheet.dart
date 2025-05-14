import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/widgets/bottomsheet/bottomsheet_widgets/bottomsheet.dart';
import 'package:revent/shared/widgets/bottomsheet/bottomsheet_widgets/bottomsheet_header.dart';
import 'package:revent/shared/widgets/bottomsheet/bottomsheet_widgets/bottomsheet_option_button.dart';

class ReportUserBottomsheet {

  Future buildBottomsheet({required BuildContext context}) {
    return Bottomsheet().buildBottomSheet(
      context: context, 
      children: [

        const BottomsheetHeader(title: 'Report Profile'),

        Align(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              'Select a report reason',
              style: GoogleFonts.inter(
                color: ThemeColor.contentThird,
                fontSize: 14,
                fontWeight: FontWeight.w800
              ),
            ),
          ),
        ),

        BottomsheetOptionButton(
          text: 'Impersonation', 
          onPressed: () {}
        ),

        BottomsheetOptionButton(
          text: 'Hacked account', 
          onPressed: () {}
        ),

        const SizedBox(height: 25)

      ]
    );
  }

}