import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revent/shared/widgets/no_content_message.dart';
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
      padding: const EdgeInsets.only(bottom: 16),
      child: DefaultVentPreviewer(
        isMyProfile: widget.isMyProfile,
        title: savedData.titles[index],
        bodyText: savedData.bodyText[index],
        tags: savedData.tags[index],
        postTimestamp: savedData.postTimestamp[index],
        totalLikes: savedData.totalLikes[index],
        totalComments: savedData.totalComments[index],
        isNsfw: savedData.isNsfw[index],
        creator: savedData.creator[index],
        pfpData: savedData.pfpData[index],
      ),
    );
  }

  Widget _buildNoSavedVents() {
    return NoContentMessage().customMessage(
      message: 'No saved vent yet.'
    );
  }

  Widget _buildListView(ProfileSavedData savedData) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 25,
      child: ListView.builder(
        itemCount: savedData.titles.length + 1,
        itemBuilder: (_, index) {
    
          if (index == 0) {
            return const SizedBox(height: 14);
          }
    
          final adjustedIndex = index - 1;
    
          if (index >= 0) {
            return KeyedSubtree(
              key: ValueKey('${savedData.titles[adjustedIndex]}/${savedData.creator[adjustedIndex]}'),
              child: _buildPreviewer(savedData, adjustedIndex),
            );
          }
    
          return const SizedBox.shrink();
    
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<ProfileSavedProvider>(
      builder: (_, savedData, __) {

        final profileSavedData = widget.isMyProfile 
          ? savedData.myProfile : savedData.userProfile;

        return profileSavedData.titles.isEmpty
          ? _buildNoSavedVents()
          : _buildListView(profileSavedData);

      },
    );
  }

}