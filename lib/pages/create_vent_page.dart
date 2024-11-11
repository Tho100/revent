import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/ui_dialog/snack_bar.dart';
import 'package:revent/vent_query/create_new_item.dart';
import 'package:revent/themes/theme_color.dart';
import 'package:revent/ui_dialog/alert_dialog.dart';
import 'package:revent/widgets/app_bar.dart';
import 'package:revent/widgets/buttons/custom_outlined_button.dart';
import 'package:revent/widgets/buttons/main_button.dart';

class CreateVentPage extends StatefulWidget {

  const CreateVentPage({super.key});

  @override
  State<CreateVentPage> createState() => CreateVentPageState();

}

class CreateVentPageState extends State<CreateVentPage> {

  final ventTitleController = TextEditingController();
  final ventBodyTextController = TextEditingController();

  final hintTextColor = ThemeColor.thirdWhite;

  Future<void> _createVentOnPressed() async {

    if(ventTitleController.text.isEmpty) {
      CustomAlertDialog.alertDialog('Please enter vent title.');
      return;
    }

    try {

      await CreateNewItem().newVent(
        ventTitle: ventTitleController.text, 
        ventBodyText: ventBodyTextController.text
      ).then((value) => {
        
        SnackBarDialog.temporarySnack(message: 'Vent has been posted.'),

        Navigator.pop(context)        

      });
        
    } catch (err) {
      SnackBarDialog.errorSnack(message: 'Failed to post vent.');
    }

  }

  Widget _buildTitleField() {
    return TextField(
      controller: ventTitleController,
      autofocus: true,
      maxLines: 1,
      maxLength: 85,
      style: GoogleFonts.inter(
        color: ThemeColor.white,
        fontWeight: FontWeight.w800,
        fontSize: 24
      ),
      decoration: InputDecoration(
        counterText: '',
        hintStyle: GoogleFonts.inter(
          color: hintTextColor,
          fontWeight: FontWeight.w800, 
          fontSize: 24
        ),
        hintText: 'Title',
        border: InputBorder.none,
        contentPadding: EdgeInsets.zero, 
      ),
    );
  }  

  Widget _buildBodyTextField() { 
    return Transform.translate(
      offset: const Offset(0, -5),
      child: TextFormField(
        controller: ventBodyTextController,
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
            color: hintTextColor,
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
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          const SizedBox(height: 4),
        
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 12.0),
            child: _buildTitleField(),
          ),   
        
          Padding(
            padding: const EdgeInsets.only(left: 17.0, right: 14.0),
            child: _buildBodyTextField(),
          ),
            
        ],
      ),
    );
  }

  Widget _buildActionButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: MainButton(
        customWidth: 100,
        text: 'Post', 
        onPressed: () async => _createVentOnPressed(),
      ),
    );
  }

  Widget _buildBottomOptions() {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 15.0, bottom: 8.0, top: 4.0),
        child: Row(
          children: [
          
            IconButton(
              onPressed: () => print('Pressed'),
              icon: const Icon(CupertinoIcons.link, color: ThemeColor.thirdWhite, size: 22),
            ),
          
            IconButton(
              onPressed: () => print('Pressed'),
              icon: const Icon(CupertinoIcons.square_list, color: ThemeColor.thirdWhite, size: 24),
            ),
          
            const Spacer(),
          
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: CustomOutlinedButton(
                customWidth: 75,
                customHeight: 35,
                customFontSize: 12,
                text: '#tags', 
                onPressed: () => print('Pressed')
              ),
            )
          
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    ventTitleController.dispose();
    ventBodyTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(
        context: context, 
        enableCenter: false,
        title: 'New vent',
        actions: [_buildActionButton()],
      ).buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomOptions(),
    );
  }
  
}