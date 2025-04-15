import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/shared/themes/theme_color.dart';

class ThemeStyle {

  static const dotSeparator = ' • ';
  
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
    color: ThemeColor.white,
    fontWeight: FontWeight.w700,
    fontSize: 13.8
  );

  static final btnBottomsheetTextStyle = GoogleFonts.inter(
    color: ThemeColor.secondaryWhite,
    fontWeight: FontWeight.w800,
    fontSize: 17,
  ); 

  static final btnBottomsheetBgStyle = ElevatedButton.styleFrom(
    backgroundColor: ThemeColor.black,
    elevation: 0,
    minimumSize: const Size(double.infinity, 55), // TODO: THis might be why it wont work
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.zero, 
    ),
  );

  static const dialogSideBorder = BorderSide(
    color: ThemeColor.lightGrey,
    width: 1
  );

  static final dialogBtnStyle = ButtonStyle(
    overlayColor: MaterialStateColor.resolveWith((_) => ThemeColor.thirdWhite),
  );
  
  static const btnBottomsheetIconColor = ThemeColor.thirdWhite;

  static InputDecoration txtFieldStye({
    required String hintText, 
    Widget? customSuffix, 
    Widget? customPrefix, 
    TextStyle? customCounterStyle,
    double? customTopPadding,
    double? customBottomPadding,
  }) {
    return InputDecoration(
      hintText: hintText,
      counterText: '',
      suffixIcon: customSuffix,
      prefixIcon: customPrefix,
      contentPadding: EdgeInsets.fromLTRB(20, customTopPadding ?? 22, 10, customBottomPadding ?? 25),
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