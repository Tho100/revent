import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/global/constant.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/pages/comment/edit_comment_page.dart';
import 'package:revent/shared/provider/user_data_provider.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/themes/theme_style.dart';
import 'package:revent/ui_dialog/snack_bar.dart';
import 'package:revent/service/query/vent/comment/vent_comment_actions.dart';
import 'package:revent/shared/widgets/bottomsheet_widgets/comment_actions.dart';
import 'package:revent/shared/widgets/profile_picture.dart';

class VentCommentPreviewer extends StatelessWidget {

  final String title;
  final String creator;

  final String commentedBy;
  final String comment;
  final String commentTimestamp;

  final int totalLikes;

  final bool isCommentLiked;
  final bool isCommentLikedByCreator;

  final Uint8List pfpData;
  final Uint8List creatorPfpData;

  VentCommentPreviewer({
    required this.title,
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

  final userData = GetIt.instance<UserDataProvider>();

  Future<void> _deleteOnPressed() async {

    try {

      await VentCommentActions(
        username: commentedBy, 
        commentText: comment, 
        ventCreator: creator, 
        ventTitle: title
      ).delete().then(
        (value) => SnackBarDialog.temporarySnack(message: 'Comment deleted.')
      );

    } catch (_) {
      SnackBarDialog.errorSnack(message: 'Something went wrong.');
    }
    
  }

  Future<void> _likeOnPressed() async {

    try {

      await VentCommentActions(
        username: commentedBy, 
        commentText: comment, 
        ventCreator: creator, 
        ventTitle: title
      ).like();

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
          editOnPressed: () {
            Navigator.pop(navigatorKey.currentContext!);
            Navigator.push(
              navigatorKey.currentContext!, 
              MaterialPageRoute(builder: (_) => EditCommentPage(
                title: title, creator: creator, originalComment: comment
                )
              )
            );
          },
          copyOnPressed: () {
            Clipboard.setData(ClipboardData(text: comment));
            Navigator.pop(navigatorKey.currentContext!);
          }, 
          reportOnPressed: () {
            Navigator.pop(navigatorKey.currentContext!);
          }, 
          blockOnPressed: () {
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

  Widget _buildLikedByCreator() {
    return Transform.translate(
      offset: const Offset(0, 3),
      child: SizedBox(
        height: 25,
        width: 25,
        child: Stack(
          children: [
      
            ProfilePictureWidget(
              pfpData: creatorPfpData,
              customEmptyPfpSize: 16,
              customWidth: 21,
              customHeight: 21,
            ),
      
            const Align(
              alignment: Alignment.bottomRight,
              child: Icon(CupertinoIcons.heart_fill, color: ThemeColor.likedColor, size: 17)
            ),
      
          ]
        ),
      ),
    );
  }

  Widget _buildLikeAndReplyButtons() {
    return Transform.translate(
      offset: const Offset(-2, 0),
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
      
          const SizedBox(width: 16),
      
          Text(
            'Reply',
            style: GoogleFonts.inter(
              color: ThemeColor.secondaryWhite,
              fontWeight: FontWeight.w800,
              fontSize: 13
            )
          ),

          const SizedBox(width: 25),

          if(isCommentLikedByCreator)
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

        _buildCommentActionButton()

      ],
    );
  }

  Widget _buildCommentText() {
    return Padding(
      padding: const EdgeInsets.only(right: 25.0),
      child: Text(
        comment,
        style: GoogleFonts.inter(
          color: ThemeColor.secondaryWhite,
          fontWeight: FontWeight.w700,
          fontSize: 14
        ),
      ),
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

            const SizedBox(height: 2),
            
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