import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/themes/theme_color.dart';
import 'package:revent/ui_dialog/snack_bar.dart';
import 'package:revent/vent_query/save_vent_edit.dart';
import 'package:revent/widgets/app_bar.dart';

class EditVentPage extends StatefulWidget {

  final String title;
  final String body;

  const EditVentPage({
    required this.title,
    required this.body,
    super.key
  });

  @override
  State<EditVentPage> createState() => EditVentPageState();
  
}

class EditVentPageState extends State<EditVentPage> {

  final ventBodyTextController = TextEditingController();

  Future<void> _saveOnPressed() async {

    try {

      final newBodyText = ventBodyTextController.text;

      await SaveVentEdit(
        title: widget.title, 
        body: widget.body, 
        newBody: newBodyText, 
      ).save().then(
        (value) => SnackBarDialog.temporarySnack(message: 'Saved changes.')
      );

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
        controller: ventBodyTextController,
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
          hintText: 'Body text (optional)',
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
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: IconButton(
        icon: const Icon(Icons.check, size: 22),
        onPressed: () async => _saveOnPressed()
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    ventBodyTextController.text = widget.body;
  }

  @override
  void dispose() {
    ventBodyTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context: context, 
        actions: [_buildActionButton()],
        title: 'Edit Vent'
      ).buildAppBar(),
      body: _buildBody(),
    );
  }

}