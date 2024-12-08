import 'dart:typed_data';

import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revent/pages/empty_page.dart';
import 'package:revent/provider/profile/profile_posts_provider.dart';
import 'package:revent/widgets/profile/posts/profile_posts_previewer.dart';

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

  Widget _buildPreviewer(
    String title, String bodyText, int totalLikes, int totalComments, String postTimestamp
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      child: Align(
        alignment: Alignment.center,
        child: ProfilePostsPreviewer(
          title: title,
          totalLikes: totalLikes,
          totalComments: totalComments,
          postTimestamp: postTimestamp,
          username: username,
          pfpData: pfpData,
        ),
      ),
    );
  }

  Widget _buildOnEmpty() {
    return EmptyPage().customMessage(
      message: 'No vent posted yet.'
    );
  }

  Widget _buildListView({
    required int itemCount,
    required List<String> titles,
    required List<String> bodyText,
    required List<int> totalLikes, 
    required List<int> totalComments, 
    required List<String> postTimestamp, 
  }) {
    return DynamicHeightGridView(
      crossAxisCount: 1,
      itemCount: itemCount,
      builder: (_, index) {
        return _buildPreviewer(
          titles[index], bodyText[index], totalLikes[index], totalComments[index], postTimestamp[index],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfilePostsProvider>(
      builder: (_, postsData, __) {

        final titles = isMyProfile 
          ? postsData.myProfile.titles 
          : postsData.userProfile.titles;

        final bodyText = isMyProfile 
          ? postsData.myProfile.bodyText 
          : postsData.userProfile.bodyText;

        final totalLikes = isMyProfile 
          ? postsData.myProfile.totalLikes 
          : postsData.userProfile.totalLikes;
        
        final totalComments = isMyProfile 
          ? postsData.myProfile.totalComments 
          : postsData.userProfile.totalComments;

        final postTimestamp = isMyProfile 
          ? postsData.myProfile.postTimestamp 
          : postsData.userProfile.postTimestamp;

        final isPostsEmpty = titles.isEmpty;
        final itemCount = titles.length;

        return isPostsEmpty 
          ? _buildOnEmpty() 
          : _buildListView(
            itemCount: itemCount, 
            titles: titles,
            bodyText: bodyText, 
            totalLikes: totalLikes, 
            totalComments: totalComments, 
            postTimestamp: postTimestamp,
          );
      },
    );
  }
    
}