import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/themes/theme_color.dart';
import 'package:revent/themes/theme_style.dart';

class MainButton extends StatelessWidget {

  final String text;
  final VoidCallback onPressed;
  final int? minusWidth;
  final int? minusHeight;

  const MainButton({
    required this.text, 
    required this.onPressed,
    this.minusWidth,
    this.minusHeight,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: minusHeight != null ? MediaQuery.of(context).size.height-minusHeight! : 68,
      width: minusWidth != null ? MediaQuery.of(context).size.width-minusWidth! : MediaQuery.of(context).size.width-50,
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