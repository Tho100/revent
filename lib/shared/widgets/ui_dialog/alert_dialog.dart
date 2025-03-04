import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/global/app_keys.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/widgets/alert_dialog_widget.dart';

class CustomAlertDialog {

  static Future alertDialog(String title) {
    return showDialog(
      barrierDismissible: false,
      context: navigatorKey.currentContext!, 
      builder: (context) {
        return AlertDialogWidget(
          title: title,
          content: '',
          actions: TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: GoogleFonts.inter(
                color: ThemeColor.secondaryWhite,
                fontWeight: FontWeight.w800,
              )
            ),
          ),
        );
      }
    );
  }
  
  static Future alertDialogTitle(String title, String messages) {
    return showDialog(
      context: navigatorKey.currentContext!,
      builder: (BuildContext context) {
        return AlertDialogWidget(
          title: title,
          content: messages,
          actions: TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: GoogleFonts.inter(
                color: ThemeColor.secondaryWhite,
                fontWeight: FontWeight.w800,
              )
            ),
          ),
        );
      },
    );
  }

  static Future alertDialogCustomOnPress({
    required String message,
    required String buttonMessage,
    required VoidCallback onPressedEvent,    
  }) {
    return showDialog(
      context: navigatorKey.currentContext!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialogWidget(
          title: message,
          content: '',
          actions: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [

              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: GoogleFonts.inter(
                    color: ThemeColor.secondaryWhite,
                    fontWeight: FontWeight.w800,
                  )
                ),
              ),

              TextButton(
                onPressed: onPressedEvent,
                child: Text(
                  buttonMessage,
                  style: GoogleFonts.inter(
                    color: ThemeColor.darkRed,
                    fontWeight: FontWeight.w800,
                  )
                ),
              ),

            ]
          ),
        );
      },
    );
  }

  static Future<bool> alertDialogDiscardConfirmation({required String message}) async {
    return await showDialog(
      context: navigatorKey.currentContext!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialogWidget(
          title: message,
          content: '',
          actions: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [

              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(
                  'Cancel',
                  style: GoogleFonts.inter(
                    color: ThemeColor.secondaryWhite,
                    fontWeight: FontWeight.w800,
                  )
                ),
              ),

              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(
                  'Discard',
                  style: GoogleFonts.inter(
                    color: ThemeColor.darkRed,
                    fontWeight: FontWeight.w800,
                  )
                ),
              ),

            ]
          ),
        );
      },
    );
  }

}