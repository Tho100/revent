import 'dart:typed_data';

import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revent/pages/empty_page.dart';
import 'package:revent/provider/profile_posts_provider.dart';
import 'package:revent/widgets/profile/profile_posts_previewer.dart';

class ProfilePostsListView extends StatelessWidget {

  final bool isMyProfile;

  final String username;
  final Uint8List pfpData;

  const ProfilePostsListView({
    required this.isMyProfile,
    required this.username,
    required this.pfpData,
    super.key
  });

  Widget _buildPreviewer(String title, int totalLikes) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      child: Align(
        alignment: Alignment.center,
        child: ProfilePostsPreviewer(
          title: title,
          totalLikes: totalLikes,
          username: username,
          pfpData: pfpData,
        ),
      ),
    );
  }

  Widget _buildOnEmpty() {
    return Padding(
      padding: const EdgeInsets.only(top: 35.0),
      child: EmptyPage().customMessage(message: 'No vent posted yet.'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfilePostsProvider>(
      builder: (_, postsData, __) {

        final titles = isMyProfile 
          ? postsData.myProfileTitles 
          : postsData.userProfileTitles;

        final totalLikes = isMyProfile 
          ? postsData.myProfileTotalLikes 
          : postsData.userProfileTotalLikes;
        
        final isPostsEmpty = titles.isEmpty;
        final itemCount = isPostsEmpty ? 1 : titles.length;

        return DynamicHeightGridView(
          shrinkWrap: true,
          itemCount: itemCount,
          mainAxisSpacing: 2,
          crossAxisCount: isPostsEmpty ? 1 : 2,
          builder: (_, index) {
            return isPostsEmpty 
              ? _buildOnEmpty() 
              : _buildPreviewer(titles[index], totalLikes[index]);
          },
        );
      },
    );
  }
    
}