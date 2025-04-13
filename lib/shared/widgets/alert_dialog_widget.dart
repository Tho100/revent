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

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        side: ThemeStyle.dialogSideBorder,
        borderRadius: BorderRadius.circular(20)
      ),
      backgroundColor: ThemeColor.black,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.60,
        height: isMultipleActions! ? 210 : 175,
        child: Column(
          children: [

            const SizedBox(height: 25),
            
            SizedBox(
              width: 225,
              child: Text(
                title,
                style: GoogleFonts.inter(
                  color: ThemeColor.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 20
                ),
                textAlign: TextAlign.center,
              ),
            ),

            if(content.isNotEmpty) ... [

              const SizedBox(height: 10),

              SizedBox(
                width: 200,
                child: Text(
                  content,
                  style: GoogleFonts.inter(
                    color: ThemeColor.secondaryWhite,
                    fontWeight: FontWeight.w800,
                    fontSize: 16
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

            ],

            const Spacer(),
    
            const Divider(color: ThemeColor.lightGrey, height: 1),

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