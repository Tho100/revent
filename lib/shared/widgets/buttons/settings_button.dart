import 'package:revent/shared/themes/theme_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/shared/widgets/inkwell_effect.dart';

class SettingsButton extends StatelessWidget {

  final String text;
  final IconData? icon;
  final VoidCallback onPressed;

  final bool? makeRed;
  final bool? hideCaret;

  const SettingsButton({
    required this.text,
    required this.onPressed,
    this.icon,
    this.makeRed,
    this.hideCaret = false,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [

        Expanded(
          child: InkWellEffect(
            onPressed: onPressed,
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const SizedBox(height: 8),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      if(icon != null) ... [

                        Icon(icon, color: makeRed == true ? ThemeColor.darkRed: ThemeColor.white, size: 21),

                        const SizedBox(width: 14)

                      ],

                      Text(
                        text,
                        style: GoogleFonts.inter(
                          color: makeRed == true ? ThemeColor.darkRed : ThemeColor.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 18
                        ),
                        textAlign: TextAlign.center
                      ),

                      const Spacer(),

                      if(!hideCaret!)
                      Icon(
                        Icons.arrow_forward_ios, 
                        color: makeRed == true ? ThemeColor.darkRed : ThemeColor.thirdWhite, 
                        size: 18
                      ),
                      
                      const SizedBox(width: 16),

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