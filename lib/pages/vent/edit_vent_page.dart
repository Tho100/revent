import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/controllers/vent_post_controller.dart';
import 'package:revent/global/alert_messages.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/widgets/text_field/post_textfield.dart';
import 'package:revent/shared/widgets/ui_dialog/alert_dialog.dart';
import 'package:revent/shared/widgets/ui_dialog/snack_bar.dart';
import 'package:revent/service/query/vent/save_vent_edit.dart';
import 'package:revent/shared/widgets/app_bar.dart';
import 'package:revent/shared/widgets/text_formatting_toolbar.dart';

class EditVentPage extends StatefulWidget {

  final String title;
  final String body;
  final bool isArchive;

  const EditVentPage({
    required this.title,
    required this.body,
    required this.isArchive,
    super.key
  });

  @override
  State<EditVentPage> createState() => _EditVentPageState();
  
}

class _EditVentPageState extends State<EditVentPage> {

  final postController = VentPostController(); 

  final isSavedNotifier = ValueNotifier<bool>(true);

  void _initializeChangesListener() {

    postController.bodyTextController.addListener(() {
      final hasChanged = postController.bodyTextController.text != widget.body;
      isSavedNotifier.value = hasChanged ? false : true;
    });

  }

  Future<void> _onSavePressed() async {

    try {

      final newBodyText = postController.bodyTextController.text;

      if(widget.isArchive) {

        await SaveVentEdit(
          title: widget.title, 
          newBody: newBodyText, 
        ).saveArchive();

      } else {

        await SaveVentEdit(
          title: widget.title, 
          newBody: newBodyText, 
        ).save();

      }

      SnackBarDialog.temporarySnack(message: AlertMessages.savedChanges);

      if(context.mounted) {
        Navigator.pop(context);
      }

    } catch (_) {
      SnackBarDialog.errorSnack(message: AlertMessages.changesFailed);
    }

  }

  Widget _buildTitle() {
    return Text(
      widget.title,
      style: GoogleFonts.inter(
        color: ThemeColor.contentPrimary,
        fontWeight: FontWeight.w800,
        fontSize: 21
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
              child: PostTextField().buildBodyField(
                bodyController: postController.bodyTextController, autoFocus: true
              ),
            ),
              
          ],
        ),
      ),
    );
  }

  Widget _buildSaveChangesButton() {
    return ValueListenableBuilder(
      valueListenable: isSavedNotifier,
      builder: (_, isSaved, __) {
        return IconButton(
          icon: Icon(Icons.check, size: 22, color: isSaved ? ThemeColor.contentThird : ThemeColor.contentPrimary),
          onPressed: () async => isSaved ? null : await _onSavePressed()
        );
      },
    );
  }

  Widget _buildTextFormattingToolbar() {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: TextFormattingToolbar(controller: postController.bodyTextController),
      )
    );
  }

  Future<bool> _onClosePage() async {

    if(postController.bodyTextController.text != widget.body) {
      return await CustomAlertDialog.alertDialogDiscardConfirmation(
        message: AlertMessages.discardEdit,
      );
    }

    return true;
    
  }

  @override
  void initState() {
    super.initState();
    postController.bodyTextController.text = widget.body;
    _initializeChangesListener();
  }

  @override
  void dispose() {
    postController.dispose();
    isSavedNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => _onClosePage(),
      child: Scaffold(
        appBar: CustomAppBar(
          context: context, 
          actions: [_buildSaveChangesButton()],
          title: 'Edit Post',
          customBackOnPressed: () async {
            if(await _onClosePage()) {
              if(context.mounted) {
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