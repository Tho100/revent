import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/global/constant.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/provider/user_data_provider.dart';
import 'package:revent/themes/theme_color.dart';
import 'package:revent/themes/theme_style.dart';
import 'package:revent/ui_dialog/snack_bar.dart';
import 'package:revent/vent_query/comment/vent_comment_actions.dart';
import 'package:revent/widgets/bottomsheet_widgets/comment_actions.dart';
import 'package:revent/widgets/profile_picture.dart';

class VentCommentPreviewer extends StatelessWidget {

  final String title;
  final String creator;

  final String commentedBy;
  final String comment;
  final String commentTimestamp;

  final Uint8List pfpData;

  VentCommentPreviewer({
    required this.title,
    required this.creator,
    required this.commentedBy,
    required this.comment,
    required this.commentTimestamp,
    required this.pfpData,
    super.key
  });

  final userData = GetIt.instance<UserDataProvider>();

  Future<void> _deleteOnPressed() async {

    try {

      await VentCommentActions(
        username: commentedBy, 
        commentText: comment, 
        ventCreator: creator, 
        ventTitle: title
      ).delete().then((value) => SnackBarDialog.temporarySnack(message: 'Comment deleted'));

    } catch (_) {
      SnackBarDialog.errorSnack(message: 'Something went wrong');
    }
    
  }

  Widget _buildCommentActionButton() {
    return SizedBox(
      width: 25,
      height: 25,
      child: IconButton(
        onPressed: () => BottomsheetCommentActions().buildBottomsheet(
          context: navigatorKey.currentContext!, 
          commenter: commentedBy, 
          copyOnPressed: () {
            Clipboard.setData(ClipboardData(text: comment));
            Navigator.pop(navigatorKey.currentContext!);
          }, 
          reportOnPressed: () {
            Navigator.pop(navigatorKey.currentContext!);
          }, 
          deleteOnPressed: () async {  
            await _deleteOnPressed();
            Navigator.pop(navigatorKey.currentContext!);
          }
        ),
        icon: Transform.translate(
          offset: const Offset(0, -10),
          child: const Icon(CupertinoIcons.ellipsis, color: ThemeColor.thirdWhite, size: 18)
        )
      ),
    );
  }

  Widget _buildProfilePicture() {
    return GestureDetector(
      onTap: () => NavigatePage.userProfilePage(username: commentedBy, pfpData: pfpData),
      child: ProfilePictureWidget(
        customHeight: 35,
        customWidth: 35,
        customEmptyPfpSize: 20,
        pfpData: pfpData
      ),
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

                GestureDetector(
                  onTap: () => NavigatePage.userProfilePage(username: commentedBy, pfpData: pfpData),
                  child: Text(
                    commentedBy,
                    style: GoogleFonts.inter(
                      color: ThemeColor.secondaryWhite,
                      fontWeight: FontWeight.w800,
                      fontSize: 14
                    )
                  ),
                ),

                const SizedBox(width: 8),

                Text(
                  '$commentTimestamp ${commentedBy == creator ? '${ThemeStyle.dotSeparator} Author' : ''}',
                  style: GoogleFonts.inter(
                    color: ThemeColor.thirdWhite,
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ),


                const Spacer(),

                _buildCommentActionButton()

              ],
            ),

            const SizedBox(height: 2),
            
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