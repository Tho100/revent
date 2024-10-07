import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/themes/theme_color.dart';

class VentPreviewer extends StatelessWidget {

  final String title;
  final String bodyText;

  const VentPreviewer({
    required this.title,
    required this.bodyText,
    super.key
  });

  Widget _buildCommunityAndCreatorHeader() {
    return Row(
      children: [

        Container(
          width: 30,
          height: 30,
          decoration: const BoxDecoration(
            color: ThemeColor.white,
            shape: BoxShape.circle
          )
        ),

        const SizedBox(width: 10),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              'motivation',
              style: GoogleFonts.inter(
                color: ThemeColor.white,
                fontWeight: FontWeight.w800,
                fontSize: 15,
              ),
            ),

            const SizedBox(height: 2.5),

            Text(
              'By dan_isgay',
              style: GoogleFonts.inter(
                color: ThemeColor.thirdWhite,
                fontWeight: FontWeight.w800,
                fontSize: 12
              ),
            ),

          ],
        ),
      ],
    );
  }

  Widget _buildTitle(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width-90,
      child: Text(
        title,
        style: GoogleFonts.inter(
          color: ThemeColor.white,
          fontWeight: FontWeight.w800,
          fontSize: 16
        ),
        overflow: TextOverflow.fade,
        softWrap: false,
      ),
    );
  }

  Widget _buildBodyText() {
    return Text(
      bodyText,
      style: GoogleFonts.inter(
        color: ThemeColor.secondaryWhite,
        fontWeight: FontWeight.w800,
        fontSize: 12.5
      ),
      overflow: TextOverflow.ellipsis,
      maxLines: 2
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Add likes/comments buttons
    return Container(
      height: 175,
      decoration: BoxDecoration(
        color: ThemeColor.black,
        border: Border.all(
          color: ThemeColor.secondaryWhite,
          width: 0.8
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            _buildCommunityAndCreatorHeader(),

            const SizedBox(height: 14),

            _buildTitle(context),

            const SizedBox(height: 12),

            _buildBodyText(),
      
          ],
        ),
      ),
    );
  }

} 