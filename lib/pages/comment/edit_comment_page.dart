import 'package:flutter/material.dart';
import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/main.dart';
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

  Future<void> _saveOnPressed() async {

    try {

      final newCommentText = commentController.text;

      if(newCommentText.isNotEmpty) {

        await SaveCommentEdit(
          originalComment: widget.originalComment, 
          newComment: newCommentText, 
        ).save().then(
          (_) => SnackBarDialog.temporarySnack(message: 'Saved changes.')
        );

      }

    } catch (_) {
      SnackBarDialog.errorSnack(message: 'Failed to save changes.');
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
                hintText: ''
              ),
            ),
          ),
            
        ],
      ),
    );
  }

  Widget _buildActionButton() {
    return IconButton(
      icon: const Icon(Icons.check, size: 22),
      onPressed: () async => _saveOnPressed()
    );
  }

  @override
  void initState() {
    super.initState();
    commentController.text = widget.originalComment;
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context: context, 
        actions: [_buildActionButton()],
        title: 'Edit comment'
      ).buildAppBar(),
      body: _buildBody(),
    );
  }

}