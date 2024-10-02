import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/themes/theme_color.dart';

class ThemeStyle {

  static const bottomDialogBorderStyle = RoundedRectangleBorder( 
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(18),
      topRight: Radius.circular(18)
    )
  );

  static final btnBottomDialogTextStyle = GoogleFonts.inter(
    color: const Color.fromARGB(255, 235, 235, 235),
    fontWeight: FontWeight.w800,
    fontSize: 16,
  ); 

  static final btnBottomDialogBackgroundStyle = ElevatedButton.styleFrom(
    backgroundColor: ThemeColor.black,
    elevation: 0,
    minimumSize: const Size(double.infinity, 55),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.zero, 
    ),
  );

}