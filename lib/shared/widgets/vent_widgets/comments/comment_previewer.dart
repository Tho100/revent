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
import 'package:revent/pages/comment/edit_comment_page.dart';
import 'package:revent/pages/reply/replies_page.dart';
import 'package:revent/service/user/actions_service.dart';
import 'package:revent/service/vent/comment/pin_service.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/themes/theme_style.dart';
import 'package:revent/shared/widgets/text/styled_text_widget.dart';
import 'package:revent/shared/widgets/ui_dialog/alert_dialog.dart';
import 'package:revent/shared/widgets/ui_dialog/snack_bar.dart';
import 'package:revent/service/vent/comment/actions_service.dart';
import 'package:revent/shared/widgets/bottomsheet/comments/actions.dart';
import 'package:revent/shared/widgets/profile/avatar_widget.dart';

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

      final deleteCommentResponse = await CommentActionsService(
        commentedBy: commentedBy, 
        commentText: comment, 
      ).delete();

      if (deleteCommentResponse['status_code'] != 204) {
        SnackBarDialog.errorSnack(message: AlertMessages.defaultError);
        return;
      }

      SnackBarDialog.temporarySnack(message: AlertMessages.commentDeleted);

      if (isOnRepliesPage) {
        Navigator.pop(AppKeys.navigatorKey.currentContext!);
      }

    } catch (_) {
      SnackBarDialog.errorSnack(message: AlertMessages.defaultError);
    }
    
  }

  Future<void> _onPinPressed() async {

    try {

      for (final comment in commentsProvider.comments) {
        if (comment.isPinned) {
          SnackBarDialog.temporarySnack(message: AlertMessages.pinnedCommentExists);
          return;
        }
      }

      final pinCommentResponse = await PinCommentService(
        username: commentedBy, 
        commentText: comment, 
      ).togglePin();

      if (pinCommentResponse['status_code'] != 200) {
        SnackBarDialog.temporarySnack(message: AlertMessages.defaultError);
        return;
      }

      SnackBarDialog.temporarySnack(message: AlertMessages.commentPinned);

    } catch (_) {
      SnackBarDialog.errorSnack(message: AlertMessages.defaultError);
    }

  }

  Future<void> _onUnpinPressed() async {

    try {

      final unpinCommentResponse = await PinCommentService(
        username: commentedBy, 
        commentText: comment, 
      ).togglePin();

      if (unpinCommentResponse['status_code'] != 200) {
        SnackBarDialog.temporarySnack(message: AlertMessages.defaultError);
        return;
      }

      SnackBarDialog.temporarySnack(message: AlertMessages.unpinnedComment);

    } catch (_) {
      SnackBarDialog.errorSnack(message: AlertMessages.defaultError);
    }

  }

  Future<void> _onLikePressed() async {

    try {

      final likeCommentResponse = await CommentActionsService(
        commentedBy: commentedBy, 
        commentText: comment, 
      ).toggleLike();

      if (likeCommentResponse['status_code'] != 200) {
        SnackBarDialog.errorSnack(message: AlertMessages.defaultError);
        return;
      }

    } catch (_) {
      SnackBarDialog.errorSnack(message: AlertMessages.defaultError);
    }
    
  }

  void _navigateToEditCommentPage() {
    Navigator.push(
      AppKeys.navigatorKey.currentContext!, 
      MaterialPageRoute(
        builder: (_) => EditCommentPage(originalComment: comment)
      )
    );
  }

  void _navigateToRepliesPage() {
    Navigator.push(
      AppKeys.navigatorKey.currentContext!,
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
  }

  void _onCopyCommentPressed() {
    TextCopy(text: comment).copy().then(
      (_) => SnackBarDialog.temporarySnack(message: AlertMessages.textCopied)
    );
  }
  
  void _onBlockPressed() {
    CustomAlertDialog.alertDialogCustomOnPress(
      message: 'Block @$commentedBy?', 
      buttonMessage: 'Block', 
      onPressedEvent: () async {
        await UserActions(username: commentedBy).toggleBlockUser().then(
          (_) => SnackBarDialog.temporarySnack(message: 'Blocked $commentedBy.')
        );
      }
    );
  }

  void _showCommentActions() {

    final context = AppKeys.navigatorKey.currentContext!;

    final commentIndex = commentsProvider.comments.indexWhere(
      (mainComment) => mainComment.commentedBy == commentedBy && mainComment.comment == comment
    );

    final isCommentPinned = commentsProvider.comments[commentIndex].isPinned;

    BottomsheetCommentActions().buildBottomsheet(
      context: context,
      commenter: commentedBy, 
      isCommentPinned: isCommentPinned,
      editOnPressed: () => context.popAndRun(_navigateToEditCommentPage),
      pinOnPressed: () => context.popAndRunAsync(_onPinPressed),
      unPinOnPressed: () => context.popAndRunAsync(_onUnpinPressed),
      copyOnPressed: () => context.popAndRun(_onCopyCommentPressed),
      blockOnPressed: () => context.popAndRun(_onBlockPressed),
      deleteOnPressed: () => context.popAndRunAsync(_onDeletePressed),
      reportOnPressed: () => Navigator.pop(context)
    );

  }

  Widget _buildCommentActionButton() {
    return SizedBox(
      width: 25,
      height: 25,
      child: IconButton(
        onPressed: _showCommentActions,
        icon: Transform.translate(
          offset: const Offset(0, -10),
          child: Icon(CupertinoIcons.ellipsis, color: ThemeColor.contentThird, size: 18)
        )
      ),
    );
  }

  Widget _buildLastEdit() {
    return GestureDetector(
      onTap: () => SnackBarDialog.temporarySnack(message: AlertMessages.editedComment),
      child: Icon(CupertinoIcons.pencil_outline, color: ThemeColor.contentThird, size: 18)
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
            onPressed: _navigateToRepliesPage,
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
      width: MediaQuery.sizeOf(context).width - 84,
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