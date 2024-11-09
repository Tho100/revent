import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/global/constant.dart';
import 'package:revent/themes/theme_color.dart';
import 'package:revent/widgets/bottomsheet_widgets/comment_actions.dart';
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

  Widget _buildCommentActionButton() {
    return SizedBox(
      width: 25,
      height: 25,
      child: IconButton(
        onPressed: () => BottomsheetCommentActions().buildBottomsheet(
          context: navigatorKey.currentContext!, 
          commenter: commentedBy, 
          copyOnPressed: () => Clipboard.setData(ClipboardData(text: comment)), 
          reportOnPressed: () {}, 
          deleteOnPressed: () {}
        ),
        icon: Transform.translate(
          offset: const Offset(0, -10),
          child: const Icon(CupertinoIcons.ellipsis, color: ThemeColor.thirdWhite, size: 18)
        )
      ),
    );
  }

  Widget _buildProfilePicture() {
    return ProfilePictureWidget(
      customHeight: 35,
      customWidth: 35,
      pfpData: pfpData
    );
  }

  Widget _buildHeaders(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 84,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 28.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row(
              children: [

                Text(
                  commentedBy,
                  style: GoogleFonts.inter(
                    color: ThemeColor.thirdWhite,
                    fontWeight: FontWeight.w800,
                    fontSize: 14
                  )
                ),

                const Spacer(),

                _buildCommentActionButton()

              ],
            ),
            
            Padding(
              padding: const EdgeInsets.only(right: 25.0),
              child: Text(
                comment,
                style: GoogleFonts.inter(
                  color: ThemeColor.secondaryWhite,
                  fontWeight: FontWeight.w700,
                  fontSize: 14
                ),
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