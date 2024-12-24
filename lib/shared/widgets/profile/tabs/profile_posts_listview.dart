import 'dart:typed_data';

import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revent/pages/empty_page.dart';
import 'package:revent/shared/provider/profile/profile_posts_provider.dart';
import 'package:revent/shared/widgets/vent_widgets/default_vent_previewer.dart';

class ProfilePostsListView extends StatefulWidget {

  final bool isMyProfile;

  final String username;
  final Uint8List pfpData;

  const ProfilePostsListView({
    required this.isMyProfile,
    required this.username,
    required this.pfpData,
    super.key
  });

  @override
  State<ProfilePostsListView> createState() => _ProfilePostsListViewState();

}

class _ProfilePostsListViewState extends State<ProfilePostsListView> with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  Widget _buildPreviewer(ProfilePostsData postsData, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      child: DefaultVentPreviewer(
        title: postsData.titles[index],
        totalLikes: postsData.totalLikes[index],
        totalComments: postsData.totalComments[index],
        bodyText: postsData.bodyText[index],
        postTimestamp: postsData.postTimestamp[index],
        creator: widget.username,
        pfpData: widget.pfpData,
      ),
    );
  }

  Widget _buildOnEmpty() {
    return EmptyPage().customMessage(
      message: 'No vent posted yet.'
    );
  }

  Widget _buildListView(ProfilePostsData postsData) {
    return DynamicHeightGridView(
      crossAxisCount: 1,
      itemCount: postsData.titles.length,
      builder: (_, index) {
        final reversedIndex = postsData.titles.length - 1 - index;
        return KeyedSubtree(
          key: ValueKey('${postsData.titles[index]}/${widget.username}'),
          child: _buildPreviewer(postsData, reversedIndex)
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<ProfilePostsProvider>(
      builder: (_, postsData, __) {

        final activeProfile = widget.isMyProfile 
          ? postsData.myProfile : postsData.userProfile;

        final isPostsEmpty = activeProfile.titles.isEmpty;

        if(isPostsEmpty) {
          return _buildOnEmpty();
        }

        return _buildListView(activeProfile);

      },
    );
  }
  
}