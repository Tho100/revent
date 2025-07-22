import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/shared/themes/theme_color.dart';

class ThemeStyle {

  static const dotSeparator = ' • ';

  static final ventPostPageTitleStyle = GoogleFonts.inter(
    color: ThemeColor.contentPrimary,
    fontWeight: FontWeight.w800,
    fontSize: 21
  );
  
  static final ventPostPageTagsStyle = GoogleFonts.inter(
    color: ThemeColor.contentThird,
    fontWeight: FontWeight.w700,
    fontSize: 14
  );
  
  static final profilePronounsStyle = GoogleFonts.inter(
    color: ThemeColor.contentSecondary,
    fontWeight: FontWeight.w700,
    fontSize: 12.5
  );

  static final profileEmptyBioStyle = TextStyle(
    color: ThemeColor.contentThird,
    fontWeight: FontWeight.w700,
    fontSize: 14
  );

  static final profileBioStyle = GoogleFonts.inter(
    color: ThemeColor.contentPrimary,
    fontWeight: FontWeight.w700,
    fontSize: 13.8
  );

  static final btnBottomsheetTextStyle = GoogleFonts.inter(
    color: ThemeColor.contentSecondary,
    fontWeight: FontWeight.w800,
    fontSize: 17,
  ); 

  static final btnBottomsheetBgStyle = ElevatedButton.styleFrom(
    backgroundColor: ThemeColor.backgroundPrimary,
    elevation: 0,
    minimumSize: const Size(double.infinity, 55),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.zero, 
    ),
  );

  static final dialogSideBorder = BorderSide(
    color: ThemeColor.divider,
    width: 1
  );

  static final dialogBtnTextStyle = GoogleFonts.inter(
    color: ThemeColor.contentSecondary,
    fontWeight: FontWeight.w800,
    fontSize: 15
  );

  static final dialogBtnStyle = ButtonStyle(
    overlayColor: MaterialStateColor.resolveWith((_) => ThemeColor.contentThird),
  );
  
  static final btnBottomsheetIconColor = ThemeColor.contentThird;

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
        color: ThemeColor.contentThird, 
        fontWeight: FontWeight.w700
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: ThemeColor.contentThird
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          width: 2,
          color: ThemeColor.contentSecondary
        )
      )
    );
  }

}