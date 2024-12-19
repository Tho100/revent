import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/shared/themes/theme_color.dart';

class AlertDialogWidget extends StatelessWidget {

  final String title;
  final String content;
  final Widget actions;

  const AlertDialogWidget({
    required this.title,
    required this.content,
    required this.actions,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16)
      ),
      backgroundColor: ThemeColor.mediumBlack,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.75,
        height: content.isNotEmpty ? 220 : 190,
        child: Column(
          children: [

            const SizedBox(height: 25),
            
            SizedBox(
              width: 200,
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

            const SizedBox(height: 45),
    
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Divider(color: ThemeColor.lightGrey, height: 1),
            ),

            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: actions
            ),
    
          ],
        ),
      ),
    );
  }

}