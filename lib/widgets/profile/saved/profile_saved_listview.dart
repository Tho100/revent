import 'dart:typed_data';

import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:revent/pages/empty_page.dart';
import 'package:revent/provider/profile_saved_provider.dart';
import 'package:revent/provider/user_data_provider.dart';
import 'package:revent/widgets/profile/saved/profile_saved_previewer.dart';

class ProfileSavedListView extends StatelessWidget {

  final bool isMyProfile;

  ProfileSavedListView({
    required this.isMyProfile,
    super.key
  });

  final userData = GetIt.instance<UserDataProvider>();

  Widget _buildPreviewer(String creator, Uint8List pfpData, String title, int totalLikes, int totalComments, String postTimestamp) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      child: Align(
        alignment: Alignment.center,
        child: ProfileSavedPreviewer(
          isMyProfile: isMyProfile,
          title: title,
          totalLikes: totalLikes,
          totalComments: totalComments,
          postTimestamp: postTimestamp,
          username: creator,
          pfpData: pfpData,
        ),
      ),
    );
  }

  Widget _buildOnEmpty() {
    return EmptyPage().customMessage(message: 'No saved vent yet.');
  }

  Widget _buildListView({
    required int itemCount,
    required List<String> creator,
    required List<Uint8List> pfpData,
    required List<String> titles,
    required List<int> totalLikes, 
    required List<int> totalComments, 
    required List<String> postTimestamp, 
  }) {
    return DynamicHeightGridView(
      crossAxisCount: 1,
      itemCount: itemCount,
      builder: (_, index) {
        return _buildPreviewer(
          creator[index], 
          pfpData[index],
          titles[index], 
          totalLikes[index], 
          totalComments[index], 
          postTimestamp[index]
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
            creator: usernames,
            pfpData: pfpData, 
            titles: titles, 
            totalLikes: totalLikes, 
            totalComments: totalComments, 
            postTimestamp: postTimestamp
          );
      },
    );
  }
    
}