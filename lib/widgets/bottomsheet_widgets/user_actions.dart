import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/themes/theme_color.dart';
import 'package:revent/themes/theme_style.dart';
import 'package:revent/widgets/bottomsheet.dart';
import 'package:revent/widgets/bottomsheet_bar.dart';
import 'package:revent/widgets/bottomsheet_title.dart';

class BottomsheetUserActions {

  Widget _buildOptionButton({
    required String text, 
    required IconData icon, 
    required VoidCallback onPressed
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ThemeStyle.btnBottomsheetBgStyle,
      child: Row(
        children: [

          Icon(icon, color: ThemeColor.darkRed),

          const SizedBox(width: 15),

          Text(
            text,
            style: GoogleFonts.inter(
              color: ThemeColor.darkRed,
              fontWeight: FontWeight.w800,
              fontSize: 17,
            ),
          )

        ],
      )
    );
  }

  Future buildBottomsheet({
    required BuildContext context,
    required VoidCallback reportOnPressed,
    required VoidCallback blockOnPressed
  }) {
    return Bottomsheet().buildBottomSheet(
      context: context, 
      children: [

        const SizedBox(height: 12),

        const BottomsheetBar(),

        const BottomsheetTitle(title: 'User Action'),

        _buildOptionButton(
          text: 'Report',
          icon: CupertinoIcons.flag,
          onPressed: reportOnPressed
        ),

        _buildOptionButton(
          text: 'Block',
          icon: CupertinoIcons.clear_circled,
          onPressed: blockOnPressed
        ),

        const SizedBox(height: 25),

      ]
    );
  }

}