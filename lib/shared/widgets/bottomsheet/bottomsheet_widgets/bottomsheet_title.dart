import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/shared/themes/theme_color.dart';

class BottomsheetTitle extends StatelessWidget {

  final String title;

  const BottomsheetTitle({
    required this.title,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 24, top: 25.5),
        child: Column(
          children: [

            Text(
              title,
              style: GoogleFonts.inter(
                color: ThemeColor.contentSecondary,
                fontSize: 19,
                fontWeight: FontWeight.w800
              ),
            ),

            const SizedBox(height: 25),

            Divider(color: ThemeColor.divider, height: 1)

          ],
        ),
      ),
    );
  }

}