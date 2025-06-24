import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/themes/theme_style.dart';

class AlertDialogWidget extends StatelessWidget {

  final String title;
  final String content;
  final Widget actions;

  final bool? isMultipleActions;

  const AlertDialogWidget({
    required this.title,
    required this.content,
    required this.actions,
    this.isMultipleActions = false,
    super.key
  });

  double _getDialogHeight() {
    
    if (isMultipleActions! && content.isNotEmpty) {
      return 210;

    } else if (isMultipleActions! && content.isEmpty) {
      return 180;

    } else if (!isMultipleActions! && content.isEmpty) {
      return 140;

    } else if (!isMultipleActions! && content.isNotEmpty) {
      return 170;

    }

    return 100;

  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        side: ThemeStyle.dialogSideBorder,
        borderRadius: BorderRadius.circular(20)
      ),
      backgroundColor: ThemeColor.backgroundPrimary,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.55,
        height: _getDialogHeight(),
        child: Column(
          children: [

            const SizedBox(height: 25),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                title,
                style: GoogleFonts.inter(
                  color: ThemeColor.contentPrimary,
                  fontWeight: FontWeight.w800,
                  fontSize: 19
                ),
                textAlign: TextAlign.center,
              ),
            ),

            if (content.isNotEmpty) ... [

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 15.0),
                child: Text(
                  content,
                  style: GoogleFonts.inter(
                    color: ThemeColor.contentSecondary,
                    fontWeight: FontWeight.w800,
                    fontSize: 15
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

            ],

            const Spacer(),
    
            Divider(color: ThemeColor.divider, height: 1),

            Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: actions
            ),
    
          ],
        ),
      ),
    );
  }

}