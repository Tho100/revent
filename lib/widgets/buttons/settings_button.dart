import 'package:flutter/cupertino.dart';
import 'package:revent/themes/theme_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsButton extends StatelessWidget {

  final String text;
  final IconData? icon;
  final VoidCallback onPressed;

  final bool? makeRed;

  const SettingsButton({
    required this.text,
    required this.onPressed,
    this.icon,
    this.makeRed,
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

                      if(icon != null) ... [

                        Icon(icon, color: ThemeColor.white, size: 21),

                        const SizedBox(width: 14)

                      ],

                      Text(
                        text,
                        style: GoogleFonts.inter(
                          color: makeRed == true ? ThemeColor.darkRed : ThemeColor.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 19
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const Spacer(),

                      if(makeRed != true)
                      Icon(
                        Icons.arrow_forward_ios, 
                        color: makeRed == true ? ThemeColor.darkRed : ThemeColor.thirdWhite, 
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