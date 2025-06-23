import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/shared/themes/theme_color.dart';

class SubButton extends StatelessWidget {

  final String text;
  final VoidCallback onPressed;
  final double? customHeight;
  final double? customFontSize;
  final Color? customForeground;
  final bool? outlined;

  const SubButton({
    required this.text, 
    required this.onPressed,
    this.customHeight,
    this.customFontSize,
    this.customForeground,
    this.outlined = false,
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
        style: outlined! 
        ? ElevatedButton.styleFrom(
          foregroundColor: ThemeColor.contentThird,
          backgroundColor: ThemeColor.backgroundPrimary,
          side: BorderSide(
            color: ThemeColor.contentPrimary,
            width: 1.5
          ),
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(horizontal: 16), 
        ) : ElevatedButton.styleFrom(
          backgroundColor: ThemeColor.contentPrimary,
          foregroundColor: ThemeColor.contentThird,
          elevation: 0,
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(horizontal: 16), 
        ),
        child: Text(
          text,
          style: GoogleFonts.inter(
            color: customForeground ?? ThemeColor.foregroundPrimary,
            fontWeight: FontWeight.w800,
            fontSize: customFontSize ?? 13,
          ),
        ),
      ),
    );
  }

}