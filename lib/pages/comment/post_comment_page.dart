import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:revent/global/alert_messages.dart';
import 'package:revent/shared/provider_mixins.dart';
import 'package:revent/shared/provider/vent/active_vent_provider.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/widgets/text/styled_text_widget.dart';
import 'package:revent/shared/widgets/text/text_formatting_toolbar.dart';
import 'package:revent/shared/widgets/ui_dialog/alert_dialog.dart';
import 'package:revent/shared/widgets/ui_dialog/snack_bar.dart';
import 'package:revent/service/query/vent/vent_actions.dart';
import 'package:revent/shared/widgets/app_bar.dart';
import 'package:revent/shared/widgets/buttons/sub_button.dart';
import 'package:revent/shared/widgets/profile_picture.dart';
import 'package:revent/shared/widgets/text_field/body_textfield.dart';

class PostCommentPage extends StatefulWidget {

  const PostCommentPage({super.key});

  @override
  State<PostCommentPage> createState() => _PostCommentPageState();

}

class _PostCommentPageState extends State<PostCommentPage> with 
  UserProfileProviderService,
  VentProviderService,
  CommentsProviderService {

  final commentController = TextEditingController();

  Future<void> _onPostCommentPressed() async {

    try {

      final commentText = commentController.text;

      if (commentText.isNotEmpty) {

        final commentIndex = commentsProvider.comments.indexWhere(
          (comment) => comment.comment == commentText && comment.commentedBy == userProvider.user.username
        );

        if (commentIndex != -1) {
          CustomAlertDialog.alertDialogTitle("Post Failed", 'You have already posted similar comment');
          return;
        } 

        await VentActions(
          title: activeVentProvider.ventData.title, 
          creator: activeVentProvider.ventData.creator
        ).sendComment(comment: commentText).then(
          (_) => Navigator.pop(context)
        );

        SnackBarDialog.temporarySnack(message: 'Comment posted.');

      }

    } catch (_) {
      print(_.toString());
      SnackBarDialog.errorSnack(message: 'Comment failed.');
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
            pfpData: activeVentProvider.ventData.creatorPfp,
          ),
        ),

        const SizedBox(width: 10),

        Text(
          activeVentProvider.ventData.creator,
          style: GoogleFonts.inter(
            color: ThemeColor.contentSecondary,
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
            color: ThemeColor.divider,
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
                    activeVentProvider.ventData.title,
                    style: GoogleFonts.inter(
                      color: ThemeColor.contentPrimary,
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
                  
                  activeVentProvider.ventData.body.isNotEmpty 
                    ? const SizedBox(height: 30)
                    : const SizedBox.shrink()

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
            pfpData: profileProvider.profile.profilePicture
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

  Widget _buildTextFormattingToolbar() {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: TextFormattingToolbar(controller: commentController),
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
        onPressed: () async => await _onPostCommentPressed(),
      ),
    );
  }

  Future<bool> _onClosePage() async {

    if (commentController.text.isNotEmpty) {
      return await CustomAlertDialog.alertDialogDiscardConfirmation(
        message: AlertMessages.discardComment, 
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
          title: 'Add a Comment',
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