import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/themes/theme_color.dart';

class ThemeStyle {

  static const dotSeparator = ' • ';

  static final profileUsernameStyle = GoogleFonts.inter(
    color: ThemeColor.white,
    fontWeight: FontWeight.w800,
    fontSize: 20.5
  );

  static final profilePronounsStyle = GoogleFonts.inter(
    color: ThemeColor.secondaryWhite,
    fontWeight: FontWeight.w700,
    fontSize: 12.5
  );

  static const profileEmptyBioStyle = TextStyle(
    color: ThemeColor.thirdWhite,
    fontStyle: FontStyle.italic,
    fontWeight: FontWeight.w700,
    fontSize: 14
  );

  static final profileBioStyle = GoogleFonts.inter(
    color: ThemeColor.secondaryWhite,
    fontWeight: FontWeight.w700,
    fontSize: 14
  );

  static final btnBottomsheetTextStyle = GoogleFonts.inter(
    color: ThemeColor.secondaryWhite,
    fontWeight: FontWeight.w800,
    fontSize: 17,
  ); 

  static final btnBottomsheetBgStyle = ElevatedButton.styleFrom(
    backgroundColor: ThemeColor.mediumBlack,
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