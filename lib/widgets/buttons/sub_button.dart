import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/themes/theme_color.dart';

class SubButton extends StatelessWidget {

  final String text;
  final VoidCallback onPressed;
  final double? customWidth;
  final double? customHeight;
  final double? customFontSize;

  const SubButton({
    required this.text, 
    required this.onPressed,
    this.customWidth,
    this.customHeight,
    this.customFontSize,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: customHeight ?? 46, 
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: ThemeColor.white,
          foregroundColor: ThemeColor.thirdWhite,
          elevation: 0,
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(horizontal: 16), 
        ),
        child: Text(
          text,
          style: GoogleFonts.inter(
            color: ThemeColor.mediumBlack,
            fontWeight: FontWeight.w800,
            fontSize: customFontSize ?? 13,
          ),
        ),
      ),
    );
  }

}