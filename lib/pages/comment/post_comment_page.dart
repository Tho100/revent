import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/main.dart';
import 'package:revent/shared/provider/vent/active_vent_provider.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/widgets/styled_text_widget.dart';
import 'package:revent/shared/widgets/ui_dialog/alert_dialog.dart';
import 'package:revent/shared/widgets/ui_dialog/snack_bar.dart';
import 'package:revent/service/query/vent/vent_actions.dart';
import 'package:revent/shared/widgets/app_bar.dart';
import 'package:revent/shared/widgets/buttons/sub_button.dart';
import 'package:revent/shared/widgets/profile_picture.dart';
import 'package:revent/shared/widgets/text_field/body_textfield.dart';

class PostCommentPage extends StatefulWidget {

  final String title;
  final String creator;
  final Uint8List creatorPfp;
  
  const PostCommentPage({
    required this.title,
    required this.creator,
    required this.creatorPfp,
    super.key
  });

  @override
  State<PostCommentPage> createState() => _PostCommentPageState();

}

class _PostCommentPageState extends State<PostCommentPage> {

  final commentController = TextEditingController();

  void _createCommentOnPressed() async {

    try {

      final commentProvider = getIt.ventCommentProvider;
      final userData = getIt.userProvider;

      final commentText = commentController.text;

      if(commentText.isNotEmpty) {

        final commentIndex = commentProvider.ventComments.indexWhere(
          (comment) => comment.comment == commentText && comment.commentedBy == userData.user.username
        );

        if(commentIndex != -1) {
          CustomAlertDialog.alertDialogTitle("Can't post comment", 'You have already posted similar comment');
          return;
        } 

        final ventActions = VentActions(title: widget.title, creator: widget.creator);

        await ventActions.sendComment(comment: commentText)
          .then((_) => Navigator.pop(context)
        );

        SnackBarDialog.temporarySnack(message: 'Comment added.');

      }

    } catch (err) {
      SnackBarDialog.errorSnack(message: 'Failed to send comment.');
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
            pfpData: widget.creatorPfp,
          ),
        ),

        const SizedBox(width: 10),

        Text(
          widget.creator,
          style: GoogleFonts.inter(
            color: ThemeColor.secondaryWhite,
            fontWeight: FontWeight.w800,
            fontSize: 14.5
          ),
        ),

      ],
    );
  }

  Widget _buildHeader() {
    return Stack(
      children: [
    
        Positioned(
          left: 35 / 2,
          top: 0,
          bottom: 0,
          child: Container(
            width: 1,
            color: ThemeColor.lightGrey,
          ),
        ),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(width: 40),
          
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const SizedBox(height: 10),

                  SelectableText(
                    widget.title,
                    style: GoogleFonts.inter(
                      color: ThemeColor.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 21,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Consumer<ActiveVentProvider>(
                    builder: (_, data, __) {
                      return StyledTextWidget(
                        text: data.ventData.body,
                        isSelectable: true,
                      );
                    },
                  ),
                  
                  const SizedBox(height: 30),

                ],
              ),
            ),
          ],
        ),

      ],
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
            controller: commentController,
            hintText: 'Your comment...',
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

              _buildHeader(),
        
              _buildTextFieldRow(),

              const SizedBox(height: 25)
        
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
        onPressed: () => _createCommentOnPressed(),
      ),
    );
  }

  Future<bool> _onClosePage() async {

    if(commentController.text.isNotEmpty) {
      return await CustomAlertDialog.alertDialogDiscardConfirmation(
        message: 'Discard comment?', 
      );
    }

    return true;
    
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => _onClosePage(), 
      child: Scaffold(
        appBar: CustomAppBar(
          context: context, 
          title: 'Add a comment',
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