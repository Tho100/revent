import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/global/app_keys.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/themes/theme_style.dart';
import 'package:revent/shared/widgets/ui_dialog/alert_dialog_widget.dart';

class CustomAlertDialog {

  static Widget _roundedActionButton(Widget textButton) {
    return Transform.translate(
      offset: const Offset(0, 2),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: SizedBox(
          width: 220,
          height: 50,
          child: textButton
        )
      )
    );
  }

  static Future alertDialog(String title) {
    return showDialog(
      barrierDismissible: false,
      context: navigatorKey.currentContext!,
      barrierColor: ThemeColor.barrier, 
      builder: (context) {
        return AlertDialogWidget(
          title: title,
          content: '',
          actions: _roundedActionButton(
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: ThemeStyle.dialogBtnStyle,
              child: Text(
                'Close',
                style: ThemeStyle.dialogBtnTextStyle
              ),
            ),
          ),
        );
      }
    );
  }
  
  static Future alertDialogTitle(String title, String messages) {
    return showDialog(
      context: navigatorKey.currentContext!,
      barrierColor: ThemeColor.barrier,
      builder: (BuildContext context) {
        return AlertDialogWidget(
          title: title,
          content: messages,
          actions: _roundedActionButton(
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: ThemeStyle.dialogBtnStyle,
              child: Text(
                'Close',
                style: ThemeStyle.dialogBtnTextStyle
              ),
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
      barrierColor: ThemeColor.barrier,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialogWidget(
          isMultipleActions: true,
          title: message,
          content: '',
          actions: Column(
            children: [

              _roundedActionButton(
                TextButton(
                  onPressed: onPressedEvent,
                  style: ButtonStyle(
                    overlayColor: MaterialStateColor.resolveWith((_) => ThemeColor.contentThird),
                  ),
                  child: Text(
                    buttonMessage,
                    style: GoogleFonts.inter(
                      color: ThemeColor.alert,
                      fontWeight: FontWeight.w800,
                      fontSize: 15
                    )
                  ),
                ),
              ),

              const SizedBox(height: 4),

              Divider(color: ThemeColor.divider, height: 1),

              _roundedActionButton(
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: ThemeStyle.dialogBtnStyle,
                  child: Text(
                    'Cancel',
                    style: ThemeStyle.dialogBtnTextStyle
                  ),
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
      barrierColor: ThemeColor.barrier,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialogWidget(
          isMultipleActions: true,
          title: message,
          content: '',
          actions: Column(
            children: [

              _roundedActionButton(
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: ThemeStyle.dialogBtnStyle,
                  child: Text(
                    'Discard',
                    style: GoogleFonts.inter(
                      color: ThemeColor.alert,
                      fontWeight: FontWeight.w800,
                      fontSize: 15
                    )
                  ),
                ),
              ),

              const SizedBox(height: 4),

              Divider(color: ThemeColor.divider, height: 1),

              _roundedActionButton(
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  style: ThemeStyle.dialogBtnStyle,
                  child: Text(
                    'Continue Writing',
                    style: ThemeStyle.dialogBtnTextStyle
                  ),
                ),
              ),

            ]
          ),
        );
      },
    );
  }

  static Future<bool> nsfwWarningDialog() async {
    return await showDialog(
      context: navigatorKey.currentContext!,
      barrierColor: ThemeColor.barrier,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialogWidget(
          isMultipleActions: true,
          title: 'NSFW Content Warning',
          content: 'View anyway?',
          actions: Column(
            children: [

              _roundedActionButton(
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                    Navigator.of(context).pop(false);
                  },
                  style: ThemeStyle.dialogBtnStyle,
                  child: Text(
                    'Go Back',
                    style: GoogleFonts.inter(
                      color: ThemeColor.alert,
                      fontWeight: FontWeight.w800,
                      fontSize: 15
                    )
                  ),
                ),
              ),

              const SizedBox(height: 4),

              Divider(color: ThemeColor.divider, height: 1),

              _roundedActionButton(
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: ThemeStyle.dialogBtnStyle,
                  child: Text(
                    'View Post',
                    style: ThemeStyle.dialogBtnTextStyle
                  ),
                ),
              ),

            ]
          ),
        );
      },
    );
  }

}