import 'package:revent/themes/theme_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsButton extends StatelessWidget {

  final String text;
  final VoidCallback onPressed;

  const SettingsButton({
    required this.text,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

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
                          color: ThemeColor.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 22
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const Spacer(),

                      const Icon(Icons.arrow_forward_ios, color: ThemeColor.thirdWhite, size: 20),
                      
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