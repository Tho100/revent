import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/shared/themes/theme_color.dart';

class MainButton extends StatelessWidget {

  final String text;
  final VoidCallback onPressed;
  final double? customWidth;
  final double? customHeight;
  final double? customFontSize;

  const MainButton({
    required this.text, 
    required this.onPressed,
    this.customWidth,
    this.customHeight,
    this.customFontSize,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: customHeight ?? 68,
      width: customWidth ?? MediaQuery.of(context).size.width * 0.87,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: ThemeColor.white,
          foregroundColor: ThemeColor.thirdWhite,
          elevation: 0,
          shape: const StadiumBorder()
        ),
        child: Text(
          text,
          style: GoogleFonts.inter(
            color: ThemeColor.mediumBlack,
            fontWeight: FontWeight.w800,
            fontSize: customFontSize ?? 13,
          )
        ),
      ),
    );
  }

}