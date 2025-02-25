import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/controllers/vent_text_controller.dart';
import 'package:revent/global/alert_messages.dart';
import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/main.dart';
import 'package:revent/pages/archive/archived_vent_page.dart';
import 'package:revent/shared/widgets/text_field/post_textfield.dart';
import 'package:revent/shared/widgets/ui_dialog/loading/spinner_loading.dart';
import 'package:revent/shared/widgets/ui_dialog/snack_bar.dart';
import 'package:revent/service/query/vent/create_new_item.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/widgets/ui_dialog/alert_dialog.dart';
import 'package:revent/service/query/vent/verify_vent.dart';
import 'package:revent/shared/widgets/app_bar.dart';
import 'package:revent/shared/widgets/buttons/custom_outlined_button.dart';
import 'package:revent/shared/widgets/buttons/sub_button.dart';

class CreateVentPage extends StatefulWidget {

  const CreateVentPage({super.key});

  @override
  State<CreateVentPage> createState() => _CreateVentPageState();

}

class _CreateVentPageState extends State<CreateVentPage> {

  final textController = VentTextController(); 
  final postTextFields = PostTextField();

  final isArchivedVentNotifier = ValueNotifier<bool>(false);

  bool isPostPressed = false;

  Future<void> _postVentOnPressed() async {

    final ventTitle = textController.titleController.text;
    final ventBodyText = textController.bodyTextController.text;

    if(ventTitle.isEmpty) {
      CustomAlertDialog.alertDialog('Please enter post title');
      return;
    }

    if(ventTitle.length < 5) {
      CustomAlertDialog.alertDialog('Title must be at least 5 characters');
      return;
    }

    if(isPostPressed) {
      return;
    }

    try {

      final isVentAlreadyExists = await VerifyVent(title: ventTitle).ventIsAlreadyExists();

      if(isVentAlreadyExists) {
        CustomAlertDialog.alertDialog('Post with similar title already exists');
        return;
      }

      if(isArchivedVentNotifier.value) {
        await _createArchiveVent(title: ventTitle, bodyText: ventBodyText);
        return;
      }

      await _createVent(title: ventTitle, bodyText: ventBodyText);

      isPostPressed = true;
        
    } catch (_) {
      SnackBarDialog.errorSnack(message: 'Failed to post vent.');
    }

  }

  Future<void> _createArchiveVent({
    required String title,
    required String bodyText
  }) async {

    final loading = SpinnerLoading();

    if(context.mounted) {
      loading.startLoading(context: context);
    }

    await CreateNewItem().newArchiveVent(
      ventTitle: title, 
      ventBodyText: bodyText
    ).then((_) {

      loading.stopLoading();

      SnackBarDialog.temporarySnack(message: 'Added vent to archive.');
      
      Navigator.pop(context);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ArchivedVentPage())
      );

    });

  }

  Future<void> _createVent({
    required String title,
    required String bodyText
  }) async {

    final loading = SpinnerLoading();

    if(context.mounted) {
      loading.startLoading(context: context);
    }

    await CreateNewItem().newVent(
      ventTitle: title, 
      ventBodyText: bodyText
    ).then((_) {

      loading.stopLoading();

      SnackBarDialog.temporarySnack(message: 'Vent has been posted.');

      Navigator.pop(context);        

      if(getIt.navigationProvider.currentPageIndex != 0) {
        NavigatePage.homePage();
      }

    });

  }  

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          const SizedBox(height: 4),
        
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 12.0),
            child: postTextFields.buildTitleField(titleController: textController.titleController),
          ),   
        
          const SizedBox(height: 4),

          Padding(
            padding: const EdgeInsets.only(left: 17.0, right: 14.0),
            child: postTextFields.buildTitleField(titleController: textController.bodyTextController),
          ),

          const SizedBox(height: 18)
            
        ],
      ),
    );
  }

  Widget _buildPostButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SubButton(
        text: 'Post', 
        onPressed: () async => _postVentOnPressed(),
      ),
    );
  }

  Widget _buildArchiveVentCheckBox() {
    return CheckboxTheme(
      data: CheckboxThemeData(
        fillColor: MaterialStateColor.resolveWith(
          (states) => ThemeColor.thirdWhite,
        ),
        checkColor: MaterialStateColor.resolveWith(
          (states) => ThemeColor.secondaryWhite,
        ),
        overlayColor: MaterialStateColor.resolveWith(
          (states) => ThemeColor.secondaryWhite.withOpacity(0.1),
        ),
        side: const BorderSide(
          color: ThemeColor.thirdWhite,
          width: 2.0,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
      ),
      child: Row(
        children: [
          
          ValueListenableBuilder(
            valueListenable: isArchivedVentNotifier,
            builder: (_, value, __) {
              return Checkbox(
                value: value,
                onChanged: (checkedValue) {
                  isArchivedVentNotifier.value = checkedValue ?? true;
                },
              );
            },
          ),

          Text(
            'Archive',
            style: GoogleFonts.inter(
              color: ThemeColor.thirdWhite,
              fontWeight: FontWeight.w800,
              fontSize: 12,
            ),
          ),

        ],
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
              onPressed: () {},
              icon: const Icon(CupertinoIcons.link, color: ThemeColor.thirdWhite, size: 22),
            ),
          
            IconButton(
              onPressed: () {},
              icon: const Icon(CupertinoIcons.square_list, color: ThemeColor.thirdWhite, size: 24),
            ),

            _buildArchiveVentCheckBox(),
          
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

  Future<bool> _onClosePage() async {

    if(textController.bodyTextController.text.isNotEmpty || textController.titleController.text.isNotEmpty) {
      return await CustomAlertDialog.alertDialogDiscardConfirmation(
        message: AlertMessages.discardPost, 
      );
    }

    return true;
    
  }

  @override
  void dispose() {
    textController.dispose();
    isArchivedVentNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => await _onClosePage(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: CustomAppBar(
          context: context, 
          enableCenter: false,
          title: 'New vent',
          actions: [_buildPostButton()],
          customBackOnPressed: () async {
            if(await _onClosePage()) {
              if(context.mounted) {
                Navigator.pop(context);
              }
            }
          },
        ).buildAppBar(),
        body: _buildBody(),
        bottomNavigationBar: _buildBottomOptions(),
      ),
    );
  }
  
}