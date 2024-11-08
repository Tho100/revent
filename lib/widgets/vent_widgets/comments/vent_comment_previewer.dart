import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/themes/theme_color.dart';
import 'package:revent/widgets/profile_picture.dart';

class VentCommentPreviewer extends StatelessWidget {

  final String commentedBy;
  final String comment;
  final Uint8List pfpData;

  const VentCommentPreviewer({
    required this.commentedBy,
    required this.comment,
    required this.pfpData,
    super.key
  });

  Widget _buildProfilePicture() {
    return ProfilePictureWidget(
      customHeight: 35,
      customWidth: 35,
      pfpData: pfpData
    );
  }

  Widget _buildHeaders(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 110,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
      
            Text(
              commentedBy,
              style: GoogleFonts.inter(
                color: ThemeColor.thirdWhite,
                fontWeight: FontWeight.w800,
                fontSize: 14
              )
            ),
      
            const SizedBox(height: 6),
      
            Text(
              comment,
              style: GoogleFonts.inter(
                color: ThemeColor.secondaryWhite,
                fontWeight: FontWeight.w700,
                fontSize: 14
              ),
            ),
      
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: _buildProfilePicture(),
        ),

        const SizedBox(width: 12),

        _buildHeaders(context)

      ],
    );
  }

}