import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/global/app_keys.dart';
import 'package:revent/shared/themes/theme_color.dart';

class SnackBarDialog {

  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> temporarySnack({
    required String message
  }) {
    return scaffoldMessengerKey.currentState!.showSnackBar(
      SnackBar(
        shape: const StadiumBorder(),
        behavior: SnackBarBehavior.floating,
        backgroundColor: ThemeColor.contentPrimary,
        duration: const Duration(seconds: 2),
        content: Row(
          children: [

            const SizedBox(width: 4),
            
            SizedBox(
              width: 320,
              child: Text(
                message, 
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: ThemeColor.foregroundPrimary,
                  fontWeight: FontWeight.w800,
                ),
                overflow: TextOverflow.ellipsis
              ),
            ),

          ],
        ),
      )
    );
  }

  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> errorSnack({
    required String message
  }) {
    return scaffoldMessengerKey.currentState!.showSnackBar(
      SnackBar(
        shape: const StadiumBorder(),
        behavior: SnackBarBehavior.floating,
        backgroundColor: ThemeColor.alert,
        duration: const Duration(seconds: 2),
        content: Row(
          children: [

            const SizedBox(width: 4),
            
            SizedBox(
              width: 320,
              child: Text(
                message, 
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: ThemeColor.contentPrimary,
                  fontWeight: FontWeight.w800,
                ),
                overflow: TextOverflow.ellipsis
              ),
            ),

          ],
        ),
      )
    );
  }

}