import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/global/alert_messages.dart';
import 'package:revent/global/app_keys.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/helper/providers_service.dart';
import 'package:revent/helper/text_copy.dart';
import 'package:revent/service/query/user/user_actions.dart';
import 'package:revent/service/query/vent/comment/reply/reply_actions.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/themes/theme_style.dart';
import 'package:revent/shared/widgets/bottomsheet/reply_actions.dart';
import 'package:revent/shared/widgets/profile_picture.dart';
import 'package:revent/shared/widgets/styled_text_widget.dart';
import 'package:revent/shared/widgets/ui_dialog/alert_dialog.dart';
import 'package:revent/shared/widgets/ui_dialog/snack_bar.dart';

class ReplyPreviewer extends StatelessWidget with VentProviderService {

  final String comment;
  final String commentedBy;

  final String repliedBy;
  final String reply;
  final String replyTimestamp;

  final int totalLikes;

  final bool isReplyLiked;
  final bool isReplyLikedByCreator;

  final Uint8List pfpData;

  const ReplyPreviewer({
    required this.comment,
    required this.commentedBy,
    required this.repliedBy,
    required this.reply,
    required this.replyTimestamp,
    required this.totalLikes,
    required this.isReplyLiked,
    required this.isReplyLikedByCreator,
    required this.pfpData,
    super.key
  });

  Future<void> _deleteOnPressed() async {

    try {

      await ReplyActions(
        replyText: reply, 
        repliedBy: repliedBy, 
        commentText: comment, 
        commentedBy: commentedBy
      ).delete();

    } catch (_) {
      SnackBarDialog.errorSnack(message: AlertMessages.defaultError);
    }
    
  }

  Future<void> _likeOnPressed() async {

    try {

      await ReplyActions(
        replyText: reply, 
        repliedBy: repliedBy,
        commentText: comment, 
        commentedBy: commentedBy
      ).like();

    } catch (_) {
      SnackBarDialog.errorSnack(message: AlertMessages.defaultError);
    }
    
  }

  Widget _buildReplyActionButton() {
    return SizedBox(
      width: 25,
      height: 25,
      child: IconButton(
        onPressed: () => BottomsheetReplyActions().buildBottomsheet(
          context: navigatorKey.currentContext!, 
          repliedBy: repliedBy, 
          copyOnPressed: () {
            TextCopy(text: reply).copy().then(
              (_) => SnackBarDialog.temporarySnack(message: AlertMessages.textCopied)
            );          
            Navigator.pop(navigatorKey.currentContext!);
          }, 
          reportOnPressed: () {
            Navigator.pop(navigatorKey.currentContext!);
          }, 
          blockOnPressed: () {
            Navigator.pop(navigatorKey.currentContext!);
            CustomAlertDialog.alertDialogCustomOnPress(
              message: 'Block @$repliedBy?', 
              buttonMessage: 'Block', 
              onPressedEvent: () async {
                await UserActions(username: repliedBy).blockUser().then(
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
          child: Icon(CupertinoIcons.ellipsis, color: ThemeColor.thirdWhite, size: 18)
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
              pfpData: activeVentProvider.ventData.creatorPfp,
              customEmptyPfpSize: 14,
              customWidth: 18.5,
              customHeight: 18.5,
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
                  child: Padding(
                    padding: const EdgeInsets.only(left: 4, top: 2),
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
            icon: Icon(isReplyLiked ? CupertinoIcons.heart_fill : CupertinoIcons.heart, color: isReplyLiked ? ThemeColor.likedColor : ThemeColor.secondaryWhite, size: 18),
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

          if(isReplyLikedByCreator)
          _buildLikedByCreator()
      
        ],
      ),
    );
  }

  Widget _buildReplyHeader() {
    return Row(
      children: [

        GestureDetector(
          onTap: () => NavigatePage.userProfilePage(username: repliedBy, pfpData: pfpData),
          child: Text(
            repliedBy,
            style: GoogleFonts.inter(
              color: ThemeColor.secondaryWhite,
              fontWeight: FontWeight.w800,
              fontSize: 13
            )
          ),
        ),
  
        const SizedBox(width: 8),
  
        Text(
          '$replyTimestamp ${repliedBy == activeVentProvider.ventData.creator ? '${ThemeStyle.dotSeparator} Author' : ''}',
          style: GoogleFonts.inter(
            color: ThemeColor.thirdWhite,
            fontWeight: FontWeight.w800,
            fontSize: 12,
          ),
        ),
       
        const Spacer(),

        _buildReplyActionButton(),

      ],
    );
  }

  Widget _buildReplyText() {
    return Padding(
      padding: const EdgeInsets.only(right: 25.0),
      child: StyledTextWidget(text: reply),
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