import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revent/pages/empty_page.dart';
import 'package:revent/provider/profile/profile_saved_provider.dart';
import 'package:revent/widgets/vent_widgets/default_vent_previewer.dart';

class ProfileSavedListView extends StatelessWidget {

  final bool isMyProfile;

  const ProfileSavedListView({
    required this.isMyProfile,
    super.key
  });

  Widget _buildPreviewer(ProfileSavedData savedData, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      child: DefaultVentPreviewer(
        isMyProfile: isMyProfile,
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
        return _buildPreviewer(savedData, index);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileSavedProvider>(
      builder: (_, savedData, __) {

        final activeProfile = isMyProfile 
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