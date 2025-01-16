import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revent/pages/empty_page.dart';
import 'package:revent/shared/provider/profile/profile_saved_provider.dart';
import 'package:revent/shared/widgets/vent_widgets/default_vent_previewer.dart';

class ProfileSavedListView extends StatefulWidget {

  final bool isMyProfile;
  final bool isSavedHidden;

  const ProfileSavedListView({
    required this.isMyProfile,
    required this.isSavedHidden,
    super.key
  });

  @override
  State<ProfileSavedListView> createState() => _ProfileSavedListViewState();

}

class _ProfileSavedListViewState extends State<ProfileSavedListView> with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  Widget _buildPreviewer(ProfileSavedData savedData, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.5, left: 6, right: 6),
      child: DefaultVentPreviewer(
        isMyProfile: widget.isMyProfile,
        title: savedData.titles[index],
        bodyText: savedData.bodyText[index],
        totalLikes: savedData.totalLikes[index],
        totalComments: savedData.totalComments[index],
        postTimestamp: savedData.postTimestamp[index],
        creator: savedData.creator[index],
        pfpData: savedData.pfpData[index],
      ),
    );
  }

  Widget _buildOnEmpty() {
    return EmptyPage().customMessage(
      message: 'No saved vent yet.'
    );
  }

  Widget _buildListView(ProfileSavedData savedData) {
    return DynamicHeightGridView(
      crossAxisCount: 1,
      itemCount: savedData.titles.length,
      builder: (_, index) {

        if(index == 0) {
          return const SizedBox(height: 10);
        }

        final adjustedIndex = index - 1;

        final reversedIndex = savedData.titles.length - 1 - adjustedIndex;

        if(index >= 0) {
          return KeyedSubtree(
            key: ValueKey('${savedData.titles[reversedIndex]}/${savedData.creator[reversedIndex]}'),
            child: _buildPreviewer(savedData, reversedIndex),
          );
        }

        return const SizedBox.shrink();

      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<ProfileSavedProvider>(
      builder: (_, savedData, __) {

        final activeProfile = widget.isMyProfile 
          ? savedData.myProfile : savedData.userProfile;

        final isPostsEmpty = activeProfile.titles.isEmpty;

        if(isPostsEmpty) {
          return _buildOnEmpty();
        }

        return _buildListView(activeProfile);

      },
    );
  }

}