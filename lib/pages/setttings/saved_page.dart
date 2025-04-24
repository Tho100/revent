import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:revent/app/app_route.dart';
import 'package:revent/global/alert_messages.dart';
import 'package:revent/helper/providers_service.dart';
import 'package:revent/model/setup/vent_data_setup.dart';
import 'package:revent/shared/widgets/no_content_message.dart';
import 'package:revent/shared/provider/vent/saved_vent_provider.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/widgets/ui_dialog/page_loading.dart';
import 'package:revent/shared/widgets/ui_dialog/snack_bar.dart';
import 'package:revent/shared/widgets/app_bar.dart';
import 'package:revent/shared/widgets/vent_widgets/default_vent_previewer.dart';

class SavedPage extends StatefulWidget {

  const SavedPage({super.key});

  @override
  State<SavedPage> createState() => _SavedPageState();
  
}

class _SavedPageState extends State<SavedPage> with NavigationProviderService {

  final isPageLoadedNotifier = ValueNotifier<bool>(false);

  Future<void> _loadSavedVentsData() async {

    try {

      await VentDataSetup().setupSaved().then(
        (_) => isPageLoadedNotifier.value = true
      );

    } catch (_) {
      SnackBarDialog.errorSnack(message: AlertMessages.postsFailedToLoad);
    }

  }

  Widget _buildVentPreviewer(SavedVentData vents) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.5),
      child: DefaultVentPreviewer(
        title: vents.title, 
        bodyText: vents.bodyText,
        tags: vents.tags,
        postTimestamp: vents.postTimestamp, 
        creator: vents.creator, 
        totalLikes: vents.totalLikes, 
        totalComments: vents.totalComments, 
        isNsfw: vents.isNsfw,
        pfpData: vents.profilePic,
      ),
    );  
  }

  Widget _buildTotalPost(List<SavedVentData> savedVentData) {

    final postText = savedVentData.length == 1 
      ? "You saved 1 post." 
      : "You saved ${savedVentData.length} posts.";

    return Text(
      postText,
      style: GoogleFonts.inter(
        color: ThemeColor.thirdWhite,
        fontWeight: FontWeight.w800,
        fontSize: 14
      )
    );

  }

  Widget _buildListView(List<SavedVentData> savedVentData) {
    return DynamicHeightGridView(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics()
      ),
      crossAxisCount: 1,
      itemCount: savedVentData.length + 1,
      builder: (_, index) {

        if (index == 0) {
          return Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 10, top: 10, bottom: 8),
              child: _buildTotalPost(savedVentData),
            ),
          );
        }

        final adjustedIndex = index - 1;

        if (adjustedIndex >= 0 && adjustedIndex < savedVentData.length) {
          final vents = savedVentData[adjustedIndex];
          return _buildVentPreviewer(vents);
        }

        return const SizedBox.shrink();

      },
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Consumer<SavedVentProvider>(
        builder: (_, savedVentData, __) {
          return ValueListenableBuilder(
            valueListenable: isPageLoadedNotifier,
            builder: (_, isLoaded, __) {

              if (!isLoaded) {
                return const PageLoading();
              }

              final ventsData = savedVentData.vents;
              
              return ventsData.isEmpty 
                ? _buildNoSavedPosts()
                : _buildListView(ventsData);

            },
          );
        },
      ),
    );
  }

  Widget _buildNoSavedPosts() {
    return NoContentMessage().customMessage(
      message: 'No saved posts.'
    );
  }

  @override
  void initState() {
    super.initState();
    _loadSavedVentsData();
    navigationProvider.setCurrentRoute(AppRoute.savedPosts.path);
  }

  @override
  void dispose() {
    isPageLoadedNotifier.dispose();
    navigationProvider.setCurrentRoute(AppRoute.myProfile.path);
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context: context, 
        title: 'Saved'
      ).buildAppBar(),
      body: _buildBody(),
    );
  }

}