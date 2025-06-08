import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/global/alert_messages.dart';
import 'package:revent/global/app_keys.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/helper/providers_service.dart';
import 'package:revent/helper/text_copy.dart';
import 'package:revent/pages/comment/edit_comment_page.dart';
import 'package:revent/pages/comment/reply/replies_page.dart';
import 'package:revent/service/query/user/user_actions.dart';
import 'package:revent/service/query/vent/comment/pin_comment.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/themes/theme_style.dart';
import 'package:revent/shared/widgets/styled_text_widget.dart';
import 'package:revent/shared/widgets/ui_dialog/alert_dialog.dart';
import 'package:revent/shared/widgets/ui_dialog/snack_bar.dart';
import 'package:revent/service/query/vent/comment/comment_actions.dart';
import 'package:revent/shared/widgets/bottomsheet/comment_actions.dart';
import 'package:revent/shared/widgets/profile_picture.dart';

class CommentPreviewer extends StatelessWidget with VentProviderService, CommentsProviderService {

  final bool isOnRepliesPage;

  final String commentedBy;
  final String comment;
  final String commentTimestamp;

  final int totalLikes;
  final int totalReplies;

  final bool isCommentLiked;
  final bool isCommentLikedByCreator;
  final bool isPinned;
  final bool isEdited;

  final Uint8List pfpData;

  CommentPreviewer({
    required this.isOnRepliesPage,
    required this.commentedBy,
    required this.comment,
    required this.commentTimestamp,
    required this.totalLikes,
    required this.totalReplies,
    required this.isCommentLiked,
    required this.isCommentLikedByCreator,
    required this.isPinned,
    required this.isEdited,
    required this.pfpData,
    super.key
  });

  Future<void> _onDeletePressed() async {

    try {

      await CommentActions(
        username: commentedBy, 
        commentText: comment, 
      ).delete().then(
        (_) => SnackBarDialog.temporarySnack(message: 'Comment deleted.')
      );

      if (isOnRepliesPage) {
        Navigator.pop(navigatorKey.currentContext!);
      }

    } catch (_) {
      SnackBarDialog.errorSnack(message: AlertMessages.defaultError);
    }
    
  }

  Future<void> _onPinPressed() async {

    try {

      for (final comment in commentsProvider.comments) {
        if (comment.isPinned) {
          SnackBarDialog.temporarySnack(message: 'You already have a pinned comment.');
          return;
        }
      }

      await PinComment(
        username: commentedBy, 
        commentText: comment, 
      ).pin().then(
        (_) => SnackBarDialog.temporarySnack(message: 'Pinned Comment.')
      );

    } catch (_) {
      SnackBarDialog.errorSnack(message: AlertMessages.defaultError);
    }

  }

  Future<void> _onUnpinPressed() async {

    try {

      await PinComment(
        username: commentedBy, 
        commentText: comment, 
      ).unpin().then(
        (_) => SnackBarDialog.temporarySnack(message: 'Removed comment from pinned.')
      );

    } catch (_) {
      SnackBarDialog.errorSnack(message: AlertMessages.defaultError);
    }

  }

  Future<void> _onLikePressed() async {

    try {

      await CommentActions(
        username: commentedBy, 
        commentText: comment, 
      ).like();

    } catch (_) {
      SnackBarDialog.errorSnack(message: AlertMessages.defaultError);
    }
    
  }

  Widget _buildLastEdit() {
    return GestureDetector(
      onTap: () => SnackBarDialog.temporarySnack(message: 'This comment was edited.'),
      child: Icon(CupertinoIcons.pencil_outline, color: ThemeColor.contentThird, size: 18)
    );
  }

  Widget _buildCommentActionButton() {
    return SizedBox(
      width: 25,
      height: 25,
      child: IconButton(
        onPressed: () => BottomsheetCommentActions().buildBottomsheet(
          context: navigatorKey.currentContext!, 
          commenter: commentedBy, 
          commentIndex: commentsProvider.comments.indexWhere(
            (mainComment) => mainComment.commentedBy == commentedBy && mainComment.comment == comment
          ),
          editOnPressed: () {
            Navigator.pop(navigatorKey.currentContext!);
            Navigator.push(
              navigatorKey.currentContext!, 
              MaterialPageRoute(
                builder: (_) => EditCommentPage(originalComment: comment)
              )
            );
          },
          pinOnPressed: () async {
            await _onPinPressed();
            Navigator.pop(navigatorKey.currentContext!);
          },
          unPinOnPressed: () async {
            await _onUnpinPressed();
            Navigator.pop(navigatorKey.currentContext!);
          },
          copyOnPressed: () {
            TextCopy(text: comment).copy().then(
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
            await _onDeletePressed();
            Navigator.pop(navigatorKey.currentContext!);
          }
        ),
        icon: Transform.translate(
          offset: const Offset(0, -10),
          child: Icon(CupertinoIcons.ellipsis, color: ThemeColor.contentThird, size: 18)
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

  Widget _buildLikeAndReplyButtons() {
    return Transform.translate(
      offset: const Offset(-2, -2),
      child: Row(
        children: [
      
          IconButton(
            onPressed: () async => await _onLikePressed(),
            icon: Icon(isCommentLiked ? CupertinoIcons.heart_fill : CupertinoIcons.heart, color: isCommentLiked ? ThemeColor.likedColor : ThemeColor.contentSecondary, size: 18),
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
      
          const SizedBox(width: 16),
      
          IconButton(
            onPressed: () {
              Navigator.push(
                navigatorKey.currentContext!,
                MaterialPageRoute(
                  builder: (_) => RepliesPage(
                    commentedBy: commentedBy, 
                    comment: comment, 
                    commentTimestamp: commentTimestamp, 
                    isCommentLikedByCreator: isCommentLikedByCreator, 
                    pfpData: pfpData, 
                  )
                )
              );
            },
            icon: Icon(CupertinoIcons.chat_bubble, color:ThemeColor.contentSecondary, size: 18),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(), 
          ),

          const SizedBox(width: 4),
      
          Text(
            totalReplies.toString(),
            style: GoogleFonts.inter(
              color: ThemeColor.contentSecondary,
              fontWeight: FontWeight.w800,
              fontSize: 13,
            ),
          ),

          const SizedBox(width: 25),

          if (isCommentLikedByCreator)
          _buildLikedByCreator()
      
        ],
      ),
    );
  }

  Widget _buildCommentHeader() {
    return Row(
      children: [

        GestureDetector(
          onTap: () => NavigatePage.userProfilePage(username: commentedBy, pfpData: pfpData),
          child: Text(
            commentedBy,
            style: GoogleFonts.inter(
              color: ThemeColor.contentSecondary,
              fontWeight: FontWeight.w800,
              fontSize: 13
            )
          ),
        ),

        const SizedBox(width: 8),

        Text(
          '$commentTimestamp ${commentedBy == activeVentProvider.ventData.creator ? '${ThemeStyle.dotSeparator} Author' : ''}',
          style: GoogleFonts.inter(
            color: ThemeColor.contentThird,
            fontWeight: FontWeight.w800,
            fontSize: 12,
          ),
        ),

        if (isPinned) ... [

          const SizedBox(width: 6),

          Icon(CupertinoIcons.pin, color: ThemeColor.contentThird, size: 16),

        ],

        const Spacer(),
  
        if (isEdited) ... [

          _buildLastEdit(),

          const SizedBox(width: 20)

        ],

        _buildCommentActionButton()

      ],
    );
  }

  Widget _buildCommentText() {
    return Padding(
      padding: const EdgeInsets.only(right: 25.0),
      child: StyledTextWidget(text: comment),
    );
  }

  Widget _buildCommentBody(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 84,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            _buildCommentHeader(),

            const SizedBox(height: 4),
            
            _buildCommentText(),
      
            const SizedBox(height: 14),

            _buildLikeAndReplyButtons(),
      
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

        _buildCommentBody(context)

      ],
    );
  }

}