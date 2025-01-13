import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/main.dart';
import 'package:revent/service/query/vent/comment/reply/comment_reply_actions.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/widgets/ui_dialog/alert_dialog.dart';
import 'package:revent/shared/widgets/ui_dialog/snack_bar.dart';
import 'package:revent/shared/widgets/app_bar.dart';
import 'package:revent/shared/widgets/buttons/sub_button.dart';
import 'package:revent/shared/widgets/profile_picture.dart';
import 'package:revent/shared/widgets/text_field/comment_textfield.dart';

class PostReplyPage extends StatefulWidget {

  final String title;
  final String creator;

  final String comment;
  final String commentedBy;
  final Uint8List commenterPfp;
  
  const PostReplyPage({
    required this.title,
    required this.creator,
    required this.comment,
    required this.commentedBy,
    required this.commenterPfp,
    super.key
  });

  @override
  State<PostReplyPage> createState() => _PostReplyPageState();

}

class _PostReplyPageState extends State<PostReplyPage> {

  final replyController = TextEditingController();

  void _postReplyOnPressed() async {

    try {

      final replyText = replyController.text;

      if(replyText.isNotEmpty) {

        await CommentReplyActions(title: widget.title, creator: widget.creator).sendReply(
          reply: replyText, 
          commentText: widget.comment, 
          commentedBy: widget.commentedBy
        ).then((_) => Navigator.pop(context));

        SnackBarDialog.temporarySnack(message: 'Reply added.');

      }

    } catch (err) {
      SnackBarDialog.errorSnack(message: 'Failed to send reply.');
    }

  }

  Widget _buildCreatorInfo() {
    return Row(
      children: [

        SizedBox(
          width: 35,
          height: 35,
          child: ProfilePictureWidget(
            customHeight: 35,
            customWidth: 35,
            customEmptyPfpSize: 20,
            pfpData: widget.commenterPfp
          ),
        ),

        const SizedBox(width: 10),

        Text(
          widget.commentedBy,
          style: GoogleFonts.inter(
            color: ThemeColor.secondaryWhite,
            fontWeight: FontWeight.w800,
            fontSize: 14.5
          ),
        ),

      ]
    );
  }

  Widget _buildOriginalComment() {
    return Text(
      widget.comment,
      style: GoogleFonts.inter(
        color: ThemeColor.white,
        fontWeight: FontWeight.w800,
        fontSize: 17
      ),
      maxLines: 6,
    );
  }

  Widget _buildTextFieldRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        SizedBox(
          width: 35,
          height: 35,
          child: ProfilePictureWidget(
            customHeight: 35,
            customWidth: 35,
            customEmptyPfpSize: 20,
            pfpData: getIt.profileProvider.profile.profilePicture
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: CommentTextField(
            controller: replyController,
            hintText: 'Your reply...',
          )
        ),

      ],
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0, left: 16.0, right: 16.0),
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(overscroll: false),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
        
              _buildCreatorInfo(),

              const SizedBox(height: 18),

              _buildOriginalComment(),

              const SizedBox(height: 12),

              const Divider(color: ThemeColor.lightGrey),

              const SizedBox(height: 25),
        
              _buildTextFieldRow()
        
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SubButton(
        text: 'Post', 
        onPressed: () => _postReplyOnPressed(),
      ),
    );
  }

  Future<bool> _onClosePage() async {

    if(replyController.text.isNotEmpty) {
      return await CustomAlertDialog.alertDialogDiscardConfirmation(
        message: 'Discard reply?', 
      );
    }

    return true;
    
  }

  @override
  void dispose() {
    replyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => _onClosePage(), 
      child: Scaffold(
        appBar: CustomAppBar(
          context: context, 
          title: 'Add a reply',
          enableCenter: false,
          actions: [_buildActionButton()],
          customBackOnPressed: () async {
            if(await _onClosePage()) {
              if(context.mounted) {
                Navigator.pop(context);
              }
            }
          },
        ).buildAppBar(),
        body: _buildBody(),
      ),
    );
  }
  
}