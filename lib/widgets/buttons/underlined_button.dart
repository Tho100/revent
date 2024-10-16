import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/themes/theme_color.dart';

class UnderlinedButton extends StatelessWidget {

  final String text;
  final VoidCallback onPressed;

  const UnderlinedButton({
    required this.text,
    required this.onPressed,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35,
      child: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: ThemeColor.black,
            elevation: 0,
            shadowColor: Colors.transparent,
            shape: const StadiumBorder(),
          ),
          onPressed: onPressed,
          child: Text(
            text,
            style: GoogleFonts.inter(
              color: ThemeColor.white,
              fontWeight: FontWeight.w800,
              fontSize: 15,
              decoration: TextDecoration.underline
            ),
          ),
        ),
      ),
    );
  }

}