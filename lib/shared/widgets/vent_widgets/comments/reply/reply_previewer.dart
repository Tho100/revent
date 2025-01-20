import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/global/constant.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/service/query/user/user_actions.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/themes/theme_style.dart';
import 'package:revent/shared/widgets/bottomsheet/comment_actions.dart';
import 'package:revent/shared/widgets/profile_picture.dart';
import 'package:revent/shared/widgets/styled_text_widget.dart';
import 'package:revent/shared/widgets/ui_dialog/alert_dialog.dart';
import 'package:revent/shared/widgets/ui_dialog/snack_bar.dart';

class ReplyPreviewer extends StatelessWidget {

  final String creator;

  final String commentedBy;
  final String comment;
  final String commentTimestamp;

  final int totalLikes;

  final bool isCommentLiked;
  final bool isCommentLikedByCreator;

  final Uint8List pfpData;
  final Uint8List creatorPfpData;

  const ReplyPreviewer({
    required this.creator,
    required this.commentedBy,
    required this.comment,
    required this.commentTimestamp,
    required this.totalLikes,
    required this.isCommentLiked,
    required this.isCommentLikedByCreator,
    required this.pfpData,
    required this.creatorPfpData,
    super.key
  });

  Future<void> _deleteOnPressed() async {

    try {

      //

    } catch (_) {
      SnackBarDialog.errorSnack(message: 'Something went wrong.');
    }
    
  }

  Future<void> _likeOnPressed() async {

    try {

      //

    } catch (_) {
      SnackBarDialog.errorSnack(message: 'Something went wrong.');
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
          editOnPressed: () {},
          copyOnPressed: () {
            Clipboard.setData(ClipboardData(text: comment));
            Navigator.pop(navigatorKey.currentContext!);
          }, 
          reportOnPressed: () {
            Navigator.pop(navigatorKey.currentContext!);
          }, 
          blockOnPressed: () {
            Navigator.pop(navigatorKey.currentContext!);
            CustomAlertDialog.alertDialogCustomOnPress(
              message: 'Block @$commentedBy?', 
              buttonMessage: 'Block', 
              onPressedEvent: () async {
                await UserActions(username: commentedBy).blockUser().then(
                  (_) => Navigator.pop(navigatorKey.currentContext!)
                );
              }
            );
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
    return ProfilePictureWidget(
      customHeight: 32,
      customWidth: 32,
      customEmptyPfpSize: 18,
      pfpData: pfpData
    );
  }

  Widget _buildLikedByCreator() {
    return Transform.translate(
      offset: const Offset(0, 4),
      child: SizedBox(
        height: 25,
        width: 28,
        child: Stack(
          children: [

            ProfilePictureWidget(
              pfpData: creatorPfpData,
              customEmptyPfpSize: 15,
              customWidth: 20,
              customHeight: 20,
            ),
      
            Align(
              alignment: Alignment.bottomRight,
              child: SizedBox(
                width: 16,
                height: 17,
                child: Container(
                  decoration: BoxDecoration(
                    color: ThemeColor.black,
                    borderRadius: BorderRadius.circular(360)
                  ),
                  child: const Padding(
                    padding: EdgeInsets.only(left: 4, top: 2),
                    child: Icon(CupertinoIcons.heart_fill, color: ThemeColor.likedColor, size: 12.2),
                  ),
                ),
              ),
            ),
      
          ]
        ),
      ),
    );
  }

  Widget _buildLikeButton() {
    return Transform.translate(
      offset: const Offset(-2, -2),
      child: Row(
        children: [
      
          IconButton(
            onPressed: () async => await _likeOnPressed(),
            icon: Icon(isCommentLiked ? CupertinoIcons.heart_fill : CupertinoIcons.heart, color: isCommentLiked ? ThemeColor.likedColor : ThemeColor.secondaryWhite, size: 18),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(), 
          ),
        
          const SizedBox(width: 4),
      
          Text(
            totalLikes.toString(),
            style: GoogleFonts.inter(
              color: ThemeColor.secondaryWhite,
              fontWeight: FontWeight.w800,
              fontSize: 13,
            ),
          ),
      
          const SizedBox(width: 25),

          if(isCommentLikedByCreator)
          _buildLikedByCreator()
      
        ],
      ),
    );
  }

  Widget _buildReplyHeader() {
    return Row(
      children: [

        GestureDetector(
          onTap: () => NavigatePage.userProfilePage(username: commentedBy, pfpData: pfpData),
          child: Text(
            commentedBy,
            style: GoogleFonts.inter(
              color: ThemeColor.secondaryWhite,
              fontWeight: FontWeight.w800,
              fontSize: 13
            )
          ),
        ),
  
        const SizedBox(width: 8),
  
        Text(
          '$commentTimestamp ${commentedBy == creator ? '${ThemeStyle.dotSeparator} Author' : ''}',
          style: GoogleFonts.inter(
            color: ThemeColor.thirdWhite,
            fontWeight: FontWeight.w800,
            fontSize: 12,
          ),
        ),
       
        const Spacer(),

        _buildCommentActionButton(),

      ],
    );
  }

  Widget _buildReplyText() {
    return Padding(
      padding: const EdgeInsets.only(right: 25.0),
      child: StyledTextWidget(text: comment),
    );
  }

  Widget _buildReplyBody(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 110,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
  
            _buildReplyHeader(),
  
            const SizedBox(height: 2),
            
            _buildReplyText(),
      
            const SizedBox(height: 14),
  
            _buildLikeButton(),
      
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
          padding: const EdgeInsets.only(left: 30, top: 4.0),
          child: _buildProfilePicture(),
        ),

        const SizedBox(width: 12),

        _buildReplyBody(context)

      ],
    );
  }

}