import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/themes/theme_color.dart';

class CustomOutlinedButton extends StatelessWidget {

  final String text;
  final VoidCallback onPressed;

  final double? customWidth;
  final double? customHeight;
  final double? customFontSize;

  const CustomOutlinedButton({
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
        style: ElevatedButton.styleFrom(
          foregroundColor: ThemeColor.thirdWhite,
          backgroundColor: ThemeColor.black,
          side: const BorderSide(
            color: ThemeColor.white,
            width: 1.5
          ),
          shape: const StadiumBorder(),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: GoogleFonts.inter(
            color: ThemeColor.white,
            fontWeight: FontWeight.w800,
            fontSize: customFontSize ?? 17,
          )
        ),
      ),
    );
  }

}