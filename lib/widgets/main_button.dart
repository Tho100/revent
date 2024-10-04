import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/themes/theme_color.dart';
import 'package:revent/themes/theme_style.dart';

class MainButton extends StatelessWidget {

  final String text;
  final VoidCallback onPressed;

  const MainButton({
    required this.text, 
    required this.onPressed,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 68,
      width: MediaQuery.of(context).size.width * 0.9,
      child: ElevatedButton(
        style: ThemeStyle.btnMainStyle,
        onPressed: onPressed,
        child: Text(
          text,
          style: GoogleFonts.inter(
            color: ThemeColor.mediumBlack,
            fontWeight: FontWeight.w800,
            fontSize: 17,
          )
        ),
      ),
    );
  }

}