import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:revent/controllers/vent_post_controller.dart';
import 'package:revent/global/alert_messages.dart';
import 'package:revent/global/validation_limits.dart';
import 'package:revent/global/post_tags.dart';
import 'package:revent/global/tabs_type.dart';
import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/shared/provider_mixins.dart';
import 'package:revent/main.dart';
import 'package:revent/pages/vault/vault_vent_page.dart';
import 'package:revent/shared/provider/vent/tags_provider.dart';
import 'package:revent/shared/widgets/bottomsheet/tags_bottomsheet.dart';
import 'package:revent/shared/widgets/bottomsheet/vents/vent_options_bottomsheet.dart';
import 'package:revent/shared/widgets/nsfw_widget.dart';
import 'package:revent/shared/widgets/text_field/post_textfield.dart';
import 'package:revent/shared/widgets/ui_dialog/loading/spinner_loading.dart';
import 'package:revent/shared/widgets/ui_dialog/snack_bar.dart';
import 'package:revent/service/query/vent/create_new_item.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/widgets/ui_dialog/alert_dialog.dart';
import 'package:revent/service/query/vent/vent_checker.dart';
import 'package:revent/shared/widgets/app_bar.dart';
import 'package:revent/shared/widgets/buttons/custom_outlined_button.dart';
import 'package:revent/shared/widgets/buttons/sub_button.dart';
import 'package:revent/shared/widgets/text/text_formatting_toolbar.dart';

class CreateVentPage extends StatefulWidget {

  const CreateVentPage({super.key});

  @override
  State<CreateVentPage> createState() => _CreateVentPageState();

}

class _CreateVentPageState extends State<CreateVentPage> with 
  TagsProviderService,
  VentPostController {
    
  final postTextFields = PostTextField();

  final allowCommentingNotifier = ValueNotifier<bool>(true);
  final vaultVentNotifier = ValueNotifier<bool>(false);
  final markAsNsfwNotifier = ValueNotifier<bool>(false);

  final chipsSelectedNotifier = ValueNotifier<List<bool>>(
    List<bool>.filled(PostTags.tags.length, false)
  );

  bool isPostPressed = false;

  Future<void> _onPostVentPressed() async {

    final ventTitle = titleController.text;
    final ventBodyText = bodyTextController.text;

    final tags = tagsProvider.selectedTags.isEmpty ? '' : tagsProvider.selectedTags.join(' ');

    if (ventTitle.isEmpty) {
      CustomAlertDialog.alertDialog(AlertMessages.emptyPostTitle);
      return;
    }

    if (ventTitle.length < ValidationLimits.minPostTitleLength) {
      CustomAlertDialog.alertDialog(AlertMessages.invalidPostTtitleLength);
      return;
    }

    if (isPostPressed) {
      return;
    }

    final loading = SpinnerLoading(context: context);

    if (context.mounted) {
      loading.startLoading();
    }

    try {

      final ventChecker = VentChecker(title: ventTitle);

      final isVentAlreadyExists = vaultVentNotifier.value 
        ? await ventChecker.isVaultVentExists()
        : await ventChecker.isVentExists();

      if (isVentAlreadyExists) {
        CustomAlertDialog.alertDialog(AlertMessages.postTitleExists);
        return;
      }

      if (vaultVentNotifier.value) {
        await _createVaultVent(title: ventTitle, bodyText: ventBodyText, tags: tags).then(
          (_) => SnackBarDialog.temporarySnack(message: AlertMessages.ventVaulted)
        );
        return;
      }

      await _createVent(title: ventTitle, bodyText: ventBodyText, tags: tags).then(
        (_) => SnackBarDialog.temporarySnack(message: AlertMessages.ventPosted)
      );

      isPostPressed = true;
        
    } catch (_) {
      SnackBarDialog.errorSnack(message: AlertMessages.ventPostFailed);
    }

    loading.stopLoading();

  }

  Future<void> _createVaultVent({
    required String title,
    required String bodyText,
    required String tags
  }) async {

    final ventResponse = await CreateNewItem(title: title, body: bodyText, tags: tags).newVaultVent();

    if (ventResponse['status_code'] != 201) {
      SnackBarDialog.errorSnack(message: AlertMessages.ventPostFailed);
      return;
    }
    
    if(context.mounted) {

      Navigator.pop(context);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const VaultVentPage()
        )
      );
    }

  }

  Future<void> _createVent({
    required String title,
    required String bodyText,
    required String tags
  }) async {

    final ventResponse = await CreateNewItem(title: title, body: bodyText, tags: tags).newVent(
      markedNsfw: markAsNsfwNotifier.value,
      allowCommenting: allowCommentingNotifier.value
    );

    if (ventResponse['status_code'] != 201) {
      SnackBarDialog.errorSnack(message: AlertMessages.ventPostFailed);
      return;
    }

    if(context.mounted) {
      Navigator.pop(context);        
    }

    if (getIt.navigationProvider.currentNavigation != NavigationTabs.home) {
      NavigatePage.homePage();
    }

  }  

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 12.0),
            child: postTextFields.buildTitleField(titleController: titleController),
          ),   

          _buildNsfwTag(),

          _buildSelectedTags(),
        
          const SizedBox(height: 4),

          Padding(
            padding: const EdgeInsets.only(left: 17.0, right: 14.0),
            child: postTextFields.buildBodyField(bodyController: bodyTextController),
          ),

          const SizedBox(height: 18)
            
        ],
      ),
    );
  }

  Widget _buildNsfwTag() {
    return ValueListenableBuilder(
      valueListenable: markAsNsfwNotifier, 
      builder: (_, isNsfw, __) {

        if (isNsfw) {
          return const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 17.0, bottom: 4.0),
              child: NsfwWidget(),
            ),
          );
        }

        return const SizedBox.shrink();

      } 
    );
  }

  Widget _buildSelectedTags() {
    return Selector<TagsProvider, List<String>>( 
      selector: (_, tagsData) => tagsData.selectedTags,
      builder: (_, selectedTags, __) {

        if (selectedTags.isEmpty) {
          return const SizedBox.shrink();
        }

        final tags = selectedTags.map((tag) => "#$tag").join(' ');
        
        return Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 17.0, top: 2.0, bottom: 10.0),
            child: Text(
              tags,
              style: GoogleFonts.inter(
                color: ThemeColor.contentThird,
                fontWeight: FontWeight.w700,
                fontSize: 14
              ),
              textAlign: TextAlign.left
            ),
          ),
        );

      },
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

  Widget _buildMoreOptionsButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: CustomOutlinedButton(
        customWidth: 36,
        customHeight: 35,
        customIconSize: 18,
        icon: CupertinoIcons.ellipsis_vertical,
        onPressed: () {
          BottomsheetVentOptions().buildBottomsheet(
            context: context,
            commentNotifier: allowCommentingNotifier,
            vaultNotifier: vaultVentNotifier,
            markNsfwNotifier: markAsNsfwNotifier,
          );
        }
      ),
    );
  }

  Widget _buildBottomOptions() {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Padding(
        padding: const EdgeInsets.only(right: 15.0, bottom: 8.0, top: 4.0),
        child: Row(
          children: [
          
            TextFormattingToolbar(
              controller: bodyTextController, 
              customBottomPadding: 0
            ),

            const Spacer(),
          
            _buildAddTagsButton(),

            const SizedBox(width: 10),

            _buildMoreOptionsButton()
          
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
        onPressed: () async => await _onPostVentPressed(),
      ),
    );
  }

  Future<bool> _onClosePage() async {

    if (bodyTextController.text.isNotEmpty || titleController.text.isNotEmpty) {
      return await CustomAlertDialog.alertDialogDiscardConfirmation(
        message: AlertMessages.discardPost, 
      );
    }

    return true;
    
  }

  @override
  void dispose() {
    disposeControllers();
    allowCommentingNotifier.dispose();
    vaultVentNotifier.dispose();
    markAsNsfwNotifier.dispose();
    chipsSelectedNotifier.dispose();
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
          title: 'New Vent',
          actions: [_buildPostButton()],
          customBackOnPressed: () async {
            if (await _onClosePage()) {
              if (context.mounted) {
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