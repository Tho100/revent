import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/themes/theme_color.dart';

class HeaderText extends StatelessWidget {

  final String title;
  final String subTitle;

  const HeaderText({
    required this.title,
    required this.subTitle,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          const SizedBox(height: 15),

          Text(
            title,
            style: GoogleFonts.inter(
              color: ThemeColor.white,
              fontSize: 32,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            subTitle,
            style: GoogleFonts.inter(
              color: ThemeColor.thirdWhite,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),

        ],
      ),
    );
  }

}