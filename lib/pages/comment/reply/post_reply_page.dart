import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/global/alert_messages.dart';
import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/main.dart';
import 'package:revent/service/query/vent/comment/reply/reply_actions.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/widgets/text/styled_text_widget.dart';
import 'package:revent/shared/widgets/text/text_formatting_toolbar.dart';
import 'package:revent/shared/widgets/ui_dialog/alert_dialog.dart';
import 'package:revent/shared/widgets/ui_dialog/snack_bar.dart';
import 'package:revent/shared/widgets/app_bar.dart';
import 'package:revent/shared/widgets/buttons/sub_button.dart';
import 'package:revent/shared/widgets/profile_picture.dart';
import 'package:revent/shared/widgets/text_field/body_textfield.dart';

class PostReplyPage extends StatefulWidget {

  final String comment;
  final String commentedBy;
  final Uint8List commenterPfp;
  
  const PostReplyPage({
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

  Future<void> _onPostReplyPressed() async {

    try {

      final replyText = replyController.text;

      if (replyText.isNotEmpty) {

        await ReplyActions(
          repliedBy: getIt.userProvider.user.username,
          replyText: replyText, 
          commentText: widget.comment, 
          commentedBy: widget.commentedBy
        ).sendReply().then(
          (_) => Navigator.pop(context)
        );

        SnackBarDialog.temporarySnack(message: AlertMessages.replyPosted);

      }

    } catch (_) {
      SnackBarDialog.errorSnack(message: AlertMessages.replyFailed);
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
            color: ThemeColor.contentSecondary,
            fontWeight: FontWeight.w800,
            fontSize: 14.5
          ),
        ),

      ]
    );
  }

  Widget _buildOriginalComment() {
    return Stack(
      children: [

        Positioned(
          left: 35 / 2,
          top: 0,
          bottom: 0,
          child: Container(
            width: 1,
            color: ThemeColor.divider,
          ),
        ),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(width: 45),

            SizedBox(
              width: MediaQuery.sizeOf(context).width - 85,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 25.0),
                child: StyledTextWidget(text: widget.comment),
              ),
            ),

          ]
        )

      ]
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
          child: BodyTextField(
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

              _buildOriginalComment(),

              _buildTextFieldRow(),
        
              const SizedBox(height: 25)

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormattingToolbar() {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: TextFormattingToolbar(controller: replyController),
    );
  }

  Widget _buildActionButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SubButton(
        text: 'Post', 
        onPressed: () async => await _onPostReplyPressed(),
      ),
    );
  }

  Future<bool> _onClosePage() async {

    if (replyController.text.isNotEmpty) {
      return await CustomAlertDialog.alertDialogDiscardConfirmation(
        message: AlertMessages.discardReply, 
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
          title: 'Add a Reply',
          enableCenter: false,
          actions: [_buildActionButton()],
          customBackOnPressed: () async {
            if (await _onClosePage()) {
              if (context.mounted) {
                Navigator.pop(context);
              }
            }
          },
        ).buildAppBar(),
        body: _buildBody(),
        bottomNavigationBar: _buildTextFormattingToolbar(),
      ),
    );
  }
  
}