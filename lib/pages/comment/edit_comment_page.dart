import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:revent/provider/profile/profile_data_provider.dart';
import 'package:revent/ui_dialog/snack_bar.dart';
import 'package:revent/vent_query/comment/save_comment_edit.dart';
import 'package:revent/widgets/app_bar.dart';
import 'package:revent/widgets/profile_picture.dart';
import 'package:revent/widgets/text_field/comment_textfield.dart';

class EditCommentPage extends StatefulWidget {

  final String title;
  final String creator;
  final String originalComment;

  const EditCommentPage({
    required this.title,
    required this.creator,
    required this.originalComment,
    super.key
  });

  @override
  State<EditCommentPage> createState() => EditCommentPageState();
  
}

class EditCommentPageState extends State<EditCommentPage> {

  final commentController = TextEditingController();

  Future<void> _saveOnPressed() async {

    try {

      final newCommentText = commentController.text;

      await SaveCommentEdit(
        title: widget.title,
        creator: widget.creator,
        originalComment: widget.originalComment, 
        newComment: newCommentText, 
      ).save();

      SnackBarDialog.temporarySnack(message: 'Saved changes.');

    } catch (err) {
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
              pfpData: GetIt.instance<ProfileDataProvider>().profilePicture
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: SingleChildScrollView(
              child: CommentTextField(controller: commentController),
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