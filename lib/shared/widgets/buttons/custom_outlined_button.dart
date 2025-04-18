import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/shared/themes/theme_color.dart';

class CustomOutlinedButton extends StatelessWidget {

  final VoidCallback onPressed;

  final IconData? icon;
  final String? text;

  final double? customWidth;
  final double? customHeight;
  final double? customFontSize;
  final double? customIconSize;

  const CustomOutlinedButton({
    required this.onPressed,
    this.text, 
    this.icon,
    this.customWidth, 
    this.customHeight,
    this.customFontSize,
    this.customIconSize,
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
          foregroundColor: ThemeColor.thirdWhite,
          backgroundColor: ThemeColor.black,
          side: BorderSide(
            color: ThemeColor.white,
            width: 1.5
          ),
          shape: const StadiumBorder(),
        ),
        child: icon != null 
          ? Transform.translate(
              offset: const Offset(0.5, -1),
              child: Icon(icon, color: ThemeColor.white, size: customIconSize ?? 17)
            )
          : Text(
            text!,
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