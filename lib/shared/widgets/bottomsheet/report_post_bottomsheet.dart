import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/widgets/bottomsheet/bottomsheet_widgets/bottomsheet.dart';
import 'package:revent/shared/widgets/bottomsheet/bottomsheet_widgets/bottomsheet_header.dart';
import 'package:revent/shared/widgets/bottomsheet/bottomsheet_widgets/bottomsheet_option_button.dart';

class ReportPostBottomsheet {

  Future buildBottomsheet({required BuildContext context}) {
    return Bottomsheet().buildBottomSheet(
      context: context, 
      children: [

        const BottomsheetHeader(title: 'Report Post'),

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
          text: 'Spam', 
          onPressed: () {}
        ),

        BottomsheetOptionButton(
          text: 'Scam or fraud', 
          onPressed: () {}
        ),

        BottomsheetOptionButton(
          text: 'Inappropriate content involving minors', 
          onPressed: () {}
        ),

        BottomsheetOptionButton(
          text: 'Promotion of illegal activity', 
          onPressed: () {}
        ),

        BottomsheetOptionButton(
          text: 'Encouraging self-harm or suicide', 
          onPressed: () {}
        ),

        BottomsheetOptionButton(
          text: 'Threats or harassment', 
          onPressed: () {}
        ),

        BottomsheetOptionButton(
          text: 'Impersonation or identity theft', 
          onPressed: () {}
        ),

        const SizedBox(height: 25)

      ]
    );
  }

}