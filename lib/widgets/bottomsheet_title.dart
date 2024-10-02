import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/themes/theme_color.dart';

class BottomsheetTitle extends StatelessWidget {

  final String title;

  const BottomsheetTitle({
    required this.title,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12.0, top: 25.0),
        child: Text(
          title,
          style: GoogleFonts.inter(
            color: ThemeColor.secondaryWhite,
            fontSize: 18.2,
            fontWeight: FontWeight.w800
          ),
        ),
      ),
    );
  }

}