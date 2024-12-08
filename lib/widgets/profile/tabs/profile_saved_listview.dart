import 'dart:typed_data';

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

  Widget _buildPreviewer(
    String title, String bodyText, String creator, int totalLikes, int totalComments, String postTimestamp, Uint8List pfpData
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      child: DefaultVentPreviewer(
        isMyProfile: isMyProfile,
        title: title,
        bodyText: bodyText,
        totalLikes: totalLikes,
        totalComments: totalComments,
        postTimestamp: postTimestamp,
        creator: creator,
        pfpData: pfpData,
      ),
    );
  }

  Widget _buildOnEmpty() {
    return EmptyPage().customMessage(
      message: 'No saved vent yet.'
    );
  }

  Widget _buildListView({
    required int itemCount,
    required List<String> titles,
    required List<String> bodyText,
    required List<String> creator,
    required List<int> totalLikes, 
    required List<int> totalComments, 
    required List<String> postTimestamp, 
    required List<Uint8List> pfpData,
  }) {
    return DynamicHeightGridView(
      crossAxisCount: 1,
      itemCount: itemCount,
      builder: (_, index) {
        return _buildPreviewer(
          titles[index], 
          bodyText[index],
          creator[index], 
          totalLikes[index], 
          totalComments[index], 
          postTimestamp[index],
          pfpData[index]
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileSavedProvider>(
      builder: (_, savedData, __) {

        final usernames = isMyProfile 
          ? savedData.myProfile.creator 
          : savedData.userProfile.creator;

        final pfpData = isMyProfile 
          ? savedData.myProfile.pfpData 
          : savedData.userProfile.pfpData;

        final titles = isMyProfile 
          ? savedData.myProfile.titles 
          : savedData.userProfile.titles;

        final bodyText = isMyProfile 
          ? savedData.myProfile.bodyText 
          : savedData.userProfile.bodyText;

        final totalLikes = isMyProfile 
          ? savedData.myProfile.totalLikes 
          : savedData.userProfile.totalLikes;
        
        final totalComments = isMyProfile 
          ? savedData.myProfile.totalComments 
          : savedData.userProfile.totalComments;

        final postTimestamp = isMyProfile 
          ? savedData.myProfile.postTimestamp 
          : savedData.userProfile.postTimestamp;

        final isPostsEmpty = titles.isEmpty;
        final itemCount = titles.length;

        return isPostsEmpty 
          ? _buildOnEmpty() 
          : _buildListView(
            itemCount: itemCount,
            titles: titles, 
            bodyText: bodyText,
            creator: usernames,
            totalLikes: totalLikes, 
            totalComments: totalComments, 
            postTimestamp: postTimestamp,
            pfpData: pfpData
          );
      },
    );
  }
    
}