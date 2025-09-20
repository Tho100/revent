import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:revent/app/app_route.dart';
import 'package:revent/controllers/search_controller.dart';
import 'package:revent/global/alert_messages.dart';
import 'package:revent/shared/provider_mixins.dart';
import 'package:revent/model/setup/vents_setup.dart';
import 'package:revent/shared/widgets/no_content_message.dart';
import 'package:revent/shared/provider/vent/saved_vent_provider.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/widgets/text_field/main_textfield.dart';
import 'package:revent/shared/widgets/ui_dialog/page_loading.dart';
import 'package:revent/shared/widgets/ui_dialog/snack_bar.dart';
import 'package:revent/shared/widgets/app_bar.dart';
import 'package:revent/shared/widgets/vent_widgets/default_vent_previewer.dart';

class SavedPage extends StatefulWidget {

  const SavedPage({super.key});

  @override
  State<SavedPage> createState() => _SavedPageState();
  
}

class _SavedPageState extends State<SavedPage> with 
  NavigationProviderService,
  LikedSavedProviderService,
  GeneralSearchController {

  final _isPageLoadedNotifier = ValueNotifier<bool>(false);

  List<SavedVentData> _allSavedVents = [];

  Future<void> _initializeSavedVentsData() async {

    try {

      await VentsSetup().setupSaved().then(
        (_) => _allSavedVents = savedVentProvider.vents
      );

      _isPageLoadedNotifier.value = true;

    } catch (_) {
      SnackBarDialog.errorSnack(message: AlertMessages.postsFailedToLoad);
    }

  }

  void _searchSavedVents({required String searchText}) {

    final query = searchText.trim().toLowerCase();

    if (query.isNotEmpty) {
      
      final filteredList = _allSavedVents.where((vent) {
        return vent.title.toLowerCase().contains(query);
      }).toList();

      if (filteredList.isNotEmpty) {
        savedVentProvider.setVents(filteredList);
      } 

    } else {

      savedVentProvider.setVents(_allSavedVents);

    }

  }

  Widget _buildVentPreviewer(SavedVentData vents) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DefaultVentPreviewer(
        postId: vents.postId,
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

  Widget _buildSearchBar() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * .92,
      height: 67,
      child: MainTextField(
        maxLines: 1,
        controller: searchController,
        hintText: 'Search in saved...',
        onChange: (searchText) => _searchSavedVents(searchText: searchText)
      ),
    );
  }

  Widget _buildTotalPost() {
    return Selector<SavedVentProvider, int>(
      selector: (_, savedVentData) => savedVentData.vents.length,
      builder: (_, ventCount, __) {
        
        final postText = ventCount == 1 
          ? "You saved 1 post." 
          : "You saved $ventCount posts.";

        return Text(
          postText,
          style: GoogleFonts.inter(
            color: ThemeColor.contentThird,
            fontWeight: FontWeight.w800,
            fontSize: 14
          )
        );

      },
    );
  }

  Widget _buildHeaderWidgets() {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.only(left: 10, top: 10, bottom: 12),
        child: Column(
          children: [

            _buildSearchBar(),

            const SizedBox(height: 15),

            _buildTotalPost()

          ],
        )
      )
    );
  }

  Widget _buildListView(List<SavedVentData> savedVentData) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width - 25,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics()
        ),
        itemCount: savedVentData.length + 1,
        itemBuilder: (_, index) {
    
          if (index == 0) {
            return _buildHeaderWidgets();
          }
    
          final adjustedIndex = index - 1;
    
          if (adjustedIndex >= 0 && adjustedIndex < savedVentData.length) {
    
            final vents = savedVentData[savedVentData.length - 1 - adjustedIndex];
    
            return KeyedSubtree(
              key: ValueKey('${vents.title}/${vents.creator}'),
              child: _buildVentPreviewer(vents)
            );
    
          }
    
          return const SizedBox.shrink();
    
        },
      ),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Consumer<SavedVentProvider>(
        builder: (_, savedVentData, __) {
          return ValueListenableBuilder(
            valueListenable: _isPageLoadedNotifier,
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
    _initializeSavedVentsData();
    navigationProvider.setCurrentRoute(AppRoute.profileSavedPosts);
  }

  @override
  void dispose() {
    disposeControllers();
    _isPageLoadedNotifier.dispose();
    navigationProvider.setCurrentRoute(AppRoute.myProfile);
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