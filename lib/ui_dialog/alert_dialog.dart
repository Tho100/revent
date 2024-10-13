import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/main.dart';
import 'package:revent/themes/theme_color.dart';
import 'package:revent/widgets/alert_dialog_widget.dart';

class CustomAlertDialog {

  static Future alertDialog(String message) {
    return showDialog(
      barrierDismissible: false,
      context: navigatorKey.currentContext!, 
      builder: (context) {
        return AlertDialogWidget(
          content: Text(
            message,
            style: GoogleFonts.inter(
              color: ThemeColor.white,
              fontWeight: FontWeight.w800,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), 
              child: Text(
                'OK',
                style: GoogleFonts.inter(
                  color: ThemeColor.secondaryWhite,
                  fontWeight: FontWeight.w800
                ),
              )
            ),
          ],
        );
      }
    );

  }
  
  static Future alertDialogTitle(String title, String messages) {
    return showDialog(
      context: navigatorKey.currentContext!,
      builder: (BuildContext context) {
        return AlertDialogWidget(
          title: Text(
            title,
            style: GoogleFonts.inter(
              color: ThemeColor.white,
              fontWeight: FontWeight.w800
            )
          ),
          content: Text(
            messages,
            style: GoogleFonts.inter(
              color: ThemeColor.secondaryWhite,
              fontWeight: FontWeight.w800,
            )
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'OK',
                style: GoogleFonts.inter(
                  color: ThemeColor.secondaryWhite,
                  fontWeight: FontWeight.w800,
                )
              ),
            ),
          ],
        );
      },
    );
  }

}