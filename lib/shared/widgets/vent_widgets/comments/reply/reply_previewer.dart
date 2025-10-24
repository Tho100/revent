import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/global/alert_messages.dart';
import 'package:revent/global/app_keys.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/helper/navigator_extension.dart';
import 'package:revent/shared/provider_mixins.dart';
import 'package:revent/helper/general/text_copy.dart';
import 'package:revent/service/query/user/user_actions.dart';
import 'package:revent/service/query/vent/reply/reply_actions.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/themes/theme_style.dart';
import 'package:revent/shared/widgets/bottomsheet/reply_actions.dart';
import 'package:revent/shared/widgets/profile_picture.dart';
import 'package:revent/shared/widgets/text/styled_text_widget.dart';
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

  Future<void> _onDeletePressed() async {

    try {

      final deleteReplyResponse = await ReplyActions(
        replyText: reply, 
        repliedBy: repliedBy, 
        commentText: comment, 
        commentedBy: commentedBy
      ).delete();

      if (deleteReplyResponse['status_code'] != 204) {
        SnackBarDialog.errorSnack(message: AlertMessages.defaultError);
        return;
      }

      SnackBarDialog.temporarySnack(message: AlertMessages.replyDeleted);

    } catch (_) {
      SnackBarDialog.errorSnack(message: AlertMessages.defaultError);
    }
    
  }

  Future<void> _onLikePressed() async {

    try {

      final likeReplyResponse = await ReplyActions(
        replyText: reply, 
        repliedBy: repliedBy,
        commentText: comment, 
        commentedBy: commentedBy
      ).toggleLikeReply();

      if (likeReplyResponse['status_code'] != 200) {
        SnackBarDialog.errorSnack(message: AlertMessages.defaultError);
        return;
      }

    } catch (_) {
      SnackBarDialog.errorSnack(message: AlertMessages.defaultError);
    }
    
  }

  void _onBlockPressed() {
    CustomAlertDialog.alertDialogCustomOnPress(
      message: 'Block @$repliedBy?', 
      buttonMessage: 'Block', 
      onPressedEvent: () async {
        await UserActions(username: repliedBy).toggleBlockUser().then(
          (_) => SnackBarDialog.temporarySnack(message: 'Blocked $repliedBy.')
        );
      }
    );
  }

  void _onCopyReplyPressed() {
    TextCopy(text: reply).copy().then(
      (_) => SnackBarDialog.temporarySnack(message: AlertMessages.textCopied)
    );          
  }

  void _showReplyActions() {

    final context = AppKeys.navigatorKey.currentContext!;

    BottomsheetReplyActions().buildBottomsheet(
      context: context, 
      repliedBy: repliedBy, 
      copyOnPressed: () => context.popAndRun(_onCopyReplyPressed),
      blockOnPressed: () => context.popAndRun(_onBlockPressed),
      deleteOnPressed: () => context.popAndRun(_onDeletePressed),  
      reportOnPressed: () => Navigator.pop(context),
    );
    
  }

  Widget _buildReplyActionButton() {
    return SizedBox(
      width: 25,
      height: 25,
      child: IconButton(
        onPressed: _showReplyActions,
        icon: Transform.translate(
          offset: const Offset(0, -10),
          child: Icon(CupertinoIcons.ellipsis, color: ThemeColor.contentThird, size: 18)
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
                    color: ThemeColor.backgroundPrimary,
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
            onPressed: () async => await _onLikePressed(),
            icon: Icon(isReplyLiked ? CupertinoIcons.heart_fill : CupertinoIcons.heart, color: isReplyLiked ? ThemeColor.likedColor : ThemeColor.contentSecondary, size: 18),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(), 
          ),
        
          const SizedBox(width: 4),
      
          Text(
            totalLikes.toString(),
            style: GoogleFonts.inter(
              color: ThemeColor.contentSecondary,
              fontWeight: FontWeight.w800,
              fontSize: 13,
            ),
          ),
      
          const SizedBox(width: 25),

          if (isReplyLikedByCreator)
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
              color: ThemeColor.contentSecondary,
              fontWeight: FontWeight.w800,
              fontSize: 13
            )
          ),
        ),
  
        const SizedBox(width: 8),
  
        Text(
          '$replyTimestamp ${repliedBy == activeVentProvider.ventData.creator ? '${ThemeStyle.dotSeparator} Author' : ''}',
          style: GoogleFonts.inter(
            color: ThemeColor.contentThird,
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
      width: MediaQuery.sizeOf(context).width - 110,
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