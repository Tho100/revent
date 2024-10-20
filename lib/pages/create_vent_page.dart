import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/ui_dialog/snack_bar.dart';
import 'package:revent/vent_query/create_new_item.dart';
import 'package:revent/themes/theme_color.dart';
import 'package:revent/ui_dialog/alert_dialog.dart';
import 'package:revent/widgets/app_bar.dart';

class CreateVentPage extends StatefulWidget {

  const CreateVentPage({super.key});

  @override
  State<CreateVentPage> createState() => CreateVentPageState();

}

class CreateVentPageState extends State<CreateVentPage> {

  final createItem = CreateNewItem();

  final ventTitleController = TextEditingController();
  final ventBodyTextController = TextEditingController();

  final defaultFontWeight = FontWeight.w800;

  final hintTextColor = ThemeColor.thirdWhite;

  Widget _buildTitleField() {
    return TextField(
      controller: ventTitleController,
      autofocus: true,
      maxLines: 1,
      maxLength: 85,
      style: GoogleFonts.inter(
        color: ThemeColor.white,
        fontWeight: defaultFontWeight,
        fontSize: 24
      ),
      decoration: InputDecoration(
        hintStyle: GoogleFonts.inter(
          color: hintTextColor,
          fontWeight: defaultFontWeight, 
          fontSize: 24
        ),
        hintText: "Title",
        border: InputBorder.none,
        contentPadding: EdgeInsets.zero, 
      ),
    );
  }  

  Widget _buildBodyTextField(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, -25),
      child: SizedBox(
        height: MediaQuery.of(context).size.height - 150,
        child: TextFormField(
          controller: ventBodyTextController,
          keyboardType: TextInputType.multiline,
          maxLength: 1000,
          maxLines: null,
          style: GoogleFonts.inter(
            color: ThemeColor.secondaryWhite,
            fontWeight: defaultFontWeight,
            fontSize: 16
          ),
          decoration: InputDecoration(
            hintStyle: GoogleFonts.inter(
              color: hintTextColor,
              fontWeight: defaultFontWeight, 
              fontSize: 16
            ),
            hintText: "Body text (optional)",
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero, 
          ),
        ),
      ),
    );
  }  

  Widget _buildBody(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 12.0),
          child: _buildTitleField(),
        ),   

        Padding(
          padding: const EdgeInsets.only(left: 17.0, right: 15.0),
          child: _buildBodyTextField(context),
        ),

        const Spacer()

      ],
    );
  }

  Widget _buildActionButton(BuildContext context) {
    return SizedBox(
      width: 120,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: ElevatedButton(
          onPressed: () async => _createVentOnPressed(context),
          style: ElevatedButton.styleFrom(
            foregroundColor: ThemeColor.thirdWhite,
            backgroundColor: ThemeColor.white,
            elevation: 0,
            shape: const StadiumBorder()
          ),
          child: Text(
            "Post vent",
            style: GoogleFonts.inter(
              color: ThemeColor.mediumBlack,
              fontSize: 12,
              fontWeight: FontWeight.w800
            )
          ),
        ),
      )
    );
  }

  Future<void> _createVentOnPressed(BuildContext context) async {

    if(ventTitleController.text.isEmpty) {
      CustomAlertDialog.alertDialog("Please enter vent title.");
      return;
    }

    try {

      await createItem.newVent(
        ventTitle: ventTitleController.text, 
        ventBodyText: ventBodyTextController.text
      );
        
      SnackBarDialog.temporarySnack(message: 'Vent has been posted.');

      if(context.mounted) {
        Navigator.pop(context);
      }

    } catch (err) {
      CustomAlertDialog.alertDialogTitle("Something went wrong", "Failed to post vent.");
      print(err.toString());
    }

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
      appBar: CustomAppBar(
        context: context, 
        title: "",
        actions: [_buildActionButton(context)],
      ).buildAppBar(),
      body: _buildBody(context),
    );
  }
}