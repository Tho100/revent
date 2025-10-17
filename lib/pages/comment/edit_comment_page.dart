import 'package:flutter/material.dart';
import 'package:revent/global/alert_messages.dart';
import 'package:revent/global/validation_limits.dart';
import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/main.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/widgets/text/text_formatting_toolbar.dart';
import 'package:revent/shared/widgets/ui_dialog/snack_bar.dart';
import 'package:revent/service/query/vent/comment/save_comment_edit.dart';
import 'package:revent/shared/widgets/app_bar.dart';
import 'package:revent/shared/widgets/profile_picture.dart';
import 'package:revent/shared/widgets/text_field/body_textfield.dart';

class EditCommentPage extends StatefulWidget {

  final String originalComment;

  const EditCommentPage({
    required this.originalComment,
    super.key
  });

  @override
  State<EditCommentPage> createState() => _EditCommentPageState();
  
}

class _EditCommentPageState extends State<EditCommentPage> {

  final commentController = TextEditingController();

  final isSavedNotifier = ValueNotifier<bool>(true);

  void _initializeChangesListener() {

    commentController.addListener(() {
      final hasChanged = commentController.text != widget.originalComment;
      isSavedNotifier.value = hasChanged ? false : true;
    });

  }

  Future<void> _onSavePressed() async {

    try {

      final newCommentText = commentController.text;

      if (newCommentText.isNotEmpty) {

        await SaveCommentEdit(
          originalComment: widget.originalComment, 
          newComment: newCommentText, 
        ).save().then(
          (_) => SnackBarDialog.temporarySnack(message: AlertMessages.savedChanges)
        );

      }

    } catch (_) {
      SnackBarDialog.errorSnack(message: AlertMessages.changesFailed);
    }

  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0, left: 16.0, right: 16.0),
      child: Row(
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
            child: SingleChildScrollView(
              child: BodyTextField(
                controller: commentController, 
                maxLength: ValidationLimits.maxCommentLength,
                hintText: ''
              ),
            ),
          ),
            
        ],
      ),
    );
  }

  Widget _buildTextFormattingToolbar() {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: TextFormattingToolbar(controller: commentController),
    );
  }

  Widget _buildSaveChangesButton() {
    return ValueListenableBuilder(
      valueListenable: isSavedNotifier,
      builder: (_, isSaved, __) {
        return IconButton(
          icon: Icon(Icons.check, size: 22, color: isSaved ? ThemeColor.contentThird : ThemeColor.contentPrimary),
          onPressed: isSaved ? null : _onSavePressed
        );
      }
    );
  }

  @override
  void initState() {
    super.initState();
    commentController.text = widget.originalComment;
    _initializeChangesListener();
  }

  @override
  void dispose() {
    commentController.dispose();
    isSavedNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context: context, 
        actions: [_buildSaveChangesButton()],
        title: 'Edit Comment'
      ).buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: _buildTextFormattingToolbar(),
    );
  }

}