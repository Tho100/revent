import 'package:revent/themes/theme_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsButton extends StatelessWidget {

  final String text;
  final VoidCallback onPressed;

  final bool? isSignOutButton;

  const SettingsButton({
    required this.text,
    required this.onPressed,
    this.isSignOutButton,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [

        Expanded(
          child: InkWell(
            onTap: onPressed,
            child: Padding(
              padding: const EdgeInsets.only(left: 18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const SizedBox(height: 8),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Text(
                        text,
                        style: GoogleFonts.inter(
                          color: isSignOutButton == true ? ThemeColor.darkRed : ThemeColor.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 22
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const Spacer(),

                      Icon(
                        Icons.arrow_forward_ios, 
                        color: isSignOutButton == true ? ThemeColor.darkRed : ThemeColor.thirdWhite, 
                        size: 20
                      ),
                      
                      const SizedBox(width: 25),

                    ],
                  ),

                  const SizedBox(height: 8),

                ],
              ),
            ),
          ),
        ),
        
      ],
    );
  }
  
}