import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/themes/theme_color.dart';
import 'package:revent/widgets/bottomsheet.dart';
import 'package:revent/widgets/bottomsheet_bar.dart';
import 'package:revent/widgets/bottomsheet_title.dart';
import 'package:revent/widgets/inkwell_effect.dart';

class BottomsheetAddItem {

  Widget _buildOptionButton({
    required String text, 
    required IconData icon, 
    required VoidCallback onPressed
  }) {
    return Column(
      children: [

        InkWellEffect(
          onPressed: onPressed,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: ThemeColor.thirdWhite),
            ),
            child: Icon(icon, size: 35, color: ThemeColor.white),
          ),
        ),
        
        const SizedBox(height: 12),

        Text(
          text,
          style: GoogleFonts.inter(
            color: ThemeColor.secondaryWhite,
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),

      ],
    );
  }

  Future buildBottomsheet({
    required BuildContext context,
    required VoidCallback addVentOnPressed,
    required VoidCallback addForumOnPressed
  }) {
    return Bottomsheet().buildBottomSheet(
      context: context, 
      children: [

        const SizedBox(height: 12),

        const BottomsheetBar(),

        const BottomsheetTitle(title: 'Create'),

        const SizedBox(height: 12),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            _buildOptionButton(
              text: 'Vent',
              icon: Icons.add,
              onPressed: addVentOnPressed
            ),

            const SizedBox(width: 30),

            _buildOptionButton(
              text: 'Community',
              icon: Icons.group,
              onPressed: addForumOnPressed
            ),

          ],
        ),

        const SizedBox(height: 35),

      ]
    );
  }

}