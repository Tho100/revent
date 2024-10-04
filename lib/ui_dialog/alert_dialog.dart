import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/themes/theme_color.dart';
import 'package:revent/widgets/alert_dialog_widget.dart';

class CustomAlertDialog {

  static Future alertDialog(BuildContext context, String message) {
    return showDialog(
      barrierDismissible: false,
      context: context, 
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

}