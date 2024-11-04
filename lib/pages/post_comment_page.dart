import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/themes/theme_color.dart';
import 'package:revent/ui_dialog/snack_bar.dart';
import 'package:revent/widgets/app_bar.dart';
import 'package:revent/widgets/buttons/main_button.dart';

class PostCommentPage extends StatefulWidget {

  final String title;
  
  const PostCommentPage({
    required this.title,
    super.key
  });

  @override
  State<PostCommentPage> createState() => PostCommentPageState();

}

class PostCommentPageState extends State<PostCommentPage> {

  final commentController = TextEditingController();

  void _createCommentOnPressed(BuildContext context) async {
    Navigator.pop(context);
    SnackBarDialog.temporarySnack(message: 'Comment added');
  }

  Widget _buildTitle() {
    return Text(
      widget.title,
      style: GoogleFonts.inter(
        color: ThemeColor.white,
        fontWeight: FontWeight.w800,
        fontSize: 21
      )
    );
  }

  Widget _buildCommentTextField(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, -25),
      child: SizedBox(
        height: MediaQuery.of(context).size.height - 185,
        child: TextFormField(
          controller: commentController,
          keyboardType: TextInputType.multiline,
          autofocus: true,
          maxLength: 1000,
          maxLines: null,
          style: GoogleFonts.inter(
            color: ThemeColor.secondaryWhite,
            fontWeight: FontWeight.w800,
            fontSize: 16
          ),
          decoration: InputDecoration(
            hintStyle: GoogleFonts.inter(
              color: ThemeColor.thirdWhite,
              fontWeight: FontWeight.w800, 
              fontSize: 16
            ),
            hintText: 'Your comment',
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero, 
          ),
        ),
      ),
    );
  }  

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, left: 16.0, right: 16.0),
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(overscroll: false),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
        
              _buildTitle(),

              const SizedBox(height: 12),

              const Divider(color: ThemeColor.darkWhite),

              const SizedBox(height: 30),
        
              _buildCommentTextField(context)
        
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: MainButton(
        customWidth: 100,
        text: 'Post', 
        onPressed: () async => _createCommentOnPressed(context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context: context, 
        title: 'Add a comment',
        enableCenter: false,
        actions: [_buildActionButton(context)]
      ).buildAppBar(),
      body: _buildBody(context),
    );
  }
}