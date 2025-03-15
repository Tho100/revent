import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:revent/controllers/vent_post_controller.dart';
import 'package:revent/global/alert_messages.dart';
import 'package:revent/global/post_tags.dart';
import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/helper/providers_service.dart';
import 'package:revent/main.dart';
import 'package:revent/pages/archive/archived_vent_page.dart';
import 'package:revent/shared/provider/vent/tags_provider.dart';
import 'package:revent/shared/widgets/bottomsheet/tags_bottomsheet.dart';
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

class _CreateVentPageState extends State<CreateVentPage> with TagsProviderService {

  final textController = VentPostController(); 
  final postTextFields = PostTextField();

  final loading = SpinnerLoading();

  final isArchivedVentNotifier = ValueNotifier<bool>(false);

  final chipsSelectedNotifier = ValueNotifier<List<bool>>(
    List<bool>.filled(PostTags.tags.length, false)
  );

  bool isPostPressed = false;

  Future<void> _postVentOnPressed() async {

    final ventTitle = textController.titleController.text;
    final ventBodyText = textController.bodyTextController.text;

    final tags = tagsProvider.selectedTags.isEmpty ? '' : tagsProvider.selectedTags.join(' ');

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

      await _createVent(title: ventTitle, bodyText: ventBodyText, tags: tags);

      isPostPressed = true;
        
    } catch (_) {
      SnackBarDialog.errorSnack(message: 'Failed to post vent.');
    }

  }

  Future<void> _createArchiveVent({
    required String title,
    required String bodyText
  }) async {

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
    required String bodyText,
    required String tags
  }) async {

    if(context.mounted) {
      loading.startLoading(context: context);
    }

    await CreateNewItem().newVent(
      ventTitle: title, 
      ventBodyText: bodyText,
      ventTags: tags
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
        
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 12.0),
            child: postTextFields.buildTitleField(titleController: textController.titleController),
          ),   

          _buildSelectedTags(),
        
          const SizedBox(height: 4),

          Padding(
            padding: const EdgeInsets.only(left: 17.0, right: 14.0),
            child: postTextFields.buildBodyField(bodyController: textController.bodyTextController),
          ),

          const SizedBox(height: 18)
            
        ],
      ),
    );
  }

  Widget _buildSelectedTags() {
    return Consumer<TagsProvider>(
      builder: (_, tagsProvider, __) {

        if(tagsProvider.selectedTags.isEmpty) {
          return const SizedBox.shrink();
        }

        final tags = tagsProvider.selectedTags.map((tag) => "#$tag").join(' ');
        
        return Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 17.0, top: 2.0, bottom: 10.0),
            child: Text(
              tags,
              style: GoogleFonts.inter(
                color: ThemeColor.thirdWhite,
                fontWeight: FontWeight.w700,
                fontSize: 14
              ),
              textAlign: TextAlign.left
            ),
          ),
        );

      }
    );
  }

  Widget _buildArchivePostCheckBox() {
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

          Transform.translate(
            offset: const Offset(-5, 0),
            child: Text(
              'Archive post',
              style: GoogleFonts.inter(
                color: ThemeColor.thirdWhite,
                fontWeight: FontWeight.w800,
                fontSize: 12.5,
              ),
            ),
          ),

        ],
      ),
    );
  }

  Widget _buildAddTagsButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: CustomOutlinedButton(
        customWidth: 75,
        customHeight: 35,
        customFontSize: 12,
        text: '#tags', 
        onPressed: () {
          BottomsheetTagsSelection(
            chipsSelectedNotifier: chipsSelectedNotifier, 
          ).buildBottomsheet(context: context);
        }
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
            
            _buildArchivePostCheckBox(),
          
            const Spacer(),
          
            _buildAddTagsButton()
          
          ],
        ),
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
    tagsProvider.selectedTags.clear();
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