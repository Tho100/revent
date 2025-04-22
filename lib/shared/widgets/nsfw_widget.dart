import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/shared/themes/theme_color.dart';

class NsfwWidget extends StatelessWidget {

  const NsfwWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 2.0, bottom: 6.0),
      child: Transform.translate(
        offset: const Offset(-4, 0),
        child: Container(
          width: 95,
          height: 20,
          decoration: BoxDecoration(
            color: ThemeColor.likedColor,
            borderRadius: BorderRadius.circular(25)
          ),
          child: Center(
            child: Text(
              '18+ / NSFW',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 13
              ),
            ),
          ),
        ),
      ),
    );
  }

}