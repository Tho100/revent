import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/themes/theme_color.dart';
import 'package:revent/ui_dialog/snack_bar.dart';
import 'package:revent/vent_query/comment/save_comment_edit.dart';
import 'package:revent/widgets/app_bar.dart';

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

  Widget _buildTitle() {
    return Text(
      widget.title,
      style: GoogleFonts.inter(
        color: ThemeColor.white,
        fontWeight: FontWeight.w800,
        fontSize: 21
      ),
    );
  }

  Widget _buildBodyTextField() { 
    return Transform.translate(
      offset: const Offset(0, -5),
      child: TextFormField(
        controller: commentController,
        autofocus: true,
        keyboardType: TextInputType.multiline,
        maxLength: 2850,
        maxLines: null,
        style: GoogleFonts.inter(
          color: ThemeColor.secondaryWhite,
          fontWeight: FontWeight.w700,
          fontSize: 16
        ),
        decoration: InputDecoration(
          counterText: '',
          hintStyle: GoogleFonts.inter(
            color: ThemeColor.thirdWhite,
            fontWeight: FontWeight.w700, 
            fontSize: 16
          ),
          hintText: 'Your comment',
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero, 
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
    
            const SizedBox(height: 4),
          
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 12.0, bottom: 8.0),
              child: _buildTitle(),
            ),   
          
            Padding(
              padding: const EdgeInsets.only(left: 17.0, right: 14.0),
              child: _buildBodyTextField(),
            ),
              
          ],
        ),
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
        title: 'Edit Comment'
      ).buildAppBar(),
      body: _buildBody(),
    );
  }

}