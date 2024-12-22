import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:revent/app/app_route.dart';
import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/main.dart';
import 'package:revent/model/setup/vent_data_setup.dart';
import 'package:revent/pages/empty_page.dart';
import 'package:revent/shared/provider/vent/liked_vent_provider.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/widgets/ui_dialog/snack_bar.dart';
import 'package:revent/shared/widgets/app_bar.dart';
import 'package:revent/shared/widgets/vent_widgets/default_vent_previewer.dart';

class LikedPage extends StatefulWidget {

  const LikedPage({super.key});

  @override
  State<LikedPage> createState() => _LikedPageState();
  
}

class _LikedPageState extends State<LikedPage> {

  final userData = getIt.userProvider;
  final navigation = getIt.navigationProvider;
  final likedVentData = getIt.likedVentProvider;

  final isPageLoadedNotifier = ValueNotifier<bool>(false);

  Future<void> _loadLikedVentsData() async {

    try {

      await VentDataSetup().setupLiked().then(
        (_) => isPageLoadedNotifier.value = true
      );

    } catch (err) {
      SnackBarDialog.errorSnack(message: 'Failed to load vents.');
    }

  }

  Widget _buildVentPreviewer(LikedVentData vents) {
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

  Widget _buildListView(List<LikedVentData> likedVentData) {
    return DynamicHeightGridView(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics()
      ),
      crossAxisCount: 1,
      itemCount: likedVentData.length+1,
      builder: (_, index) {

        if(index < likedVentData.length) {
          
          final reversedVentIndex = likedVentData.length - 1 - index;
          final vents = likedVentData[reversedVentIndex];

          return _buildVentPreviewer(vents);

        } else if (likedVentData.length > 9) {
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
      child: Consumer<LikedVentProvider>(
        builder: (_, likedVentData, __) {
          return ValueListenableBuilder(
            valueListenable: isPageLoadedNotifier,
            builder: (_, isLoaded, __) {

              if (!isLoaded) {
                return const Center(
                  child: CircularProgressIndicator(color: ThemeColor.white, strokeWidth: 2)
                );
              }

              final ventsData = likedVentData.vents;
              
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
      message: 'No liked posts.'
    );
  }

  @override
  void initState() {
    _loadLikedVentsData();
    navigation.setCurrentRoute(AppRoute.likedPosts);
    super.initState();
  }

  @override
  void dispose() {
    isPageLoadedNotifier.dispose();
    likedVentData.clearVents();
    navigation.setCurrentRoute(AppRoute.myProfile);
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context: context, 
        title: 'Liked'
      ).buildAppBar(),
      body: _buildBody(),
    );
  }

}