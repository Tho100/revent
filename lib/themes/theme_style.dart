import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/themes/theme_color.dart';

class ThemeStyle {

  static final btnBottomsheetTextStyle = GoogleFonts.inter(
    color: ThemeColor.secondaryWhite,
    fontWeight: FontWeight.w800,
    fontSize: 17,
  ); 

  static final btnBottomsheetBgStyle = ElevatedButton.styleFrom(
    backgroundColor: ThemeColor.black,
    elevation: 0,
    minimumSize: const Size(double.infinity, 55),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.zero, 
    ),
  );

  static InputDecoration txtFieldStye({
    required String hintText, 
    IconButton? customSuffix, 
    TextStyle? customCounterStyle
  }) {
    return InputDecoration(
      hintText: hintText,
      counterText: '',
      suffixIcon: customSuffix,
      contentPadding: const EdgeInsets.fromLTRB(20, 22, 10, 25),
      hintStyle: GoogleFonts.inter(
        color: ThemeColor.thirdWhite, 
        fontWeight: FontWeight.w700
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: ThemeColor.thirdWhite
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          width: 2,
          color: ThemeColor.secondaryWhite
        )
      )
    );
  }

}