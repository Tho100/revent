import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:revent/app/app_route.dart';
import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/main.dart';
import 'package:revent/model/setup/vent_data_setup.dart';
import 'package:revent/pages/empty_page.dart';
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

class _SavedPageState extends State<SavedPage> {

  final userData = getIt.userProvider;
  final navigation = getIt.navigationProvider;
  final savedVentData = getIt.savedVentProvider;

  final isPageLoadedNotifier = ValueNotifier<bool>(false);

  Future<void> _loadSavedVentsData() async {

    try {

      await VentDataSetup().setupSaved().then(
        (_) => isPageLoadedNotifier.value = true
      );

    } catch (err) {
      SnackBarDialog.errorSnack(message: 'Failed to load vents.');
    }

  }

  Widget _buildVentPreviewer(SavedVentData vents) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.5),
      child: DefaultVentPreviewer(
        title: vents.title, 
        bodyText: vents.bodyText,
        creator: vents.creator, 
        postTimestamp: vents.postTimestamp, 
        totalLikes: vents.totalLikes, 
        totalComments: vents.totalComments, 
        pfpData: vents.profilePic,
      ),
    );  
  }

  Widget _buildListView(List<SavedVentData> savedVentData) {
    return DynamicHeightGridView(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics()
      ),
      crossAxisCount: 1,
      itemCount: savedVentData.length+1,
      builder: (_, index) {

        if(index < savedVentData.length) {
          
          final reversedVentIndex = savedVentData.length - 1 - index;
          final vents = savedVentData[reversedVentIndex];

          return _buildVentPreviewer(vents);

        } else if (savedVentData.length > 9) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 35.0, top: 8.0),
            child: Center(
              child: Text(
                "You've reached the end.", 
                style: GoogleFonts.inter(
                  color: ThemeColor.thirdWhite,
                  fontWeight: FontWeight.w800,
                )
              ),
            ),
          );

        } else {
          return const SizedBox.shrink();

        }

      },
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 15),
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
                ? _buildOnEmpty()
                : _buildListView(ventsData);

            },
          );
        },
      ),
    );
  }

  Widget _buildOnEmpty() {
    return EmptyPage().customMessage(
      message: 'No saved posts.'
    );
  }

  @override
  void initState() {
    _loadSavedVentsData();
    navigation.setCurrentRoute(AppRoute.savedPosts);
    super.initState();
  }

  @override
  void dispose() {
    isPageLoadedNotifier.dispose();
    navigation.setCurrentRoute(AppRoute.myProfile);
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