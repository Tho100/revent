import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/themes/theme_color.dart';

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
        padding: const EdgeInsets.only(bottom: 12.5, top: 25.5),
        child: Text(
          title,
          style: GoogleFonts.inter(
            color: ThemeColor.white,
            fontSize: 19,
            fontWeight: FontWeight.w800
          ),
        ),
      ),
    );
  }

}