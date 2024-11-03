import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:revent/widgets/custom_tab_bar.dart';
import 'package:revent/widgets/profile/profile_posts_listview.dart';

class ProfileTabBarWidgets {

  final BuildContext context; // TODO: Remove unused context

  final TabController controller;
  final bool isMyProfile;

  final String username;
  final Uint8List pfpData;

  ProfileTabBarWidgets({
    required this.context,
    required this.controller,
    required this.isMyProfile,
    required this.username,
    required this.pfpData
  });

  Widget buildTabBarTabs() {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 12.0),
      child: TabBarView(
        controller: controller,
        children: [
          ProfilePostsListView(isMyProfile: isMyProfile, username: username, pfpData: pfpData),
          Container(),
        ],
      ),
    );
  }

  Widget buildTabBar() {
    return CustomTabBar(
      controller: controller, 
      tabAlignment: TabAlignment.fill,
      tabs: const [
        Tab(icon: Icon(CupertinoIcons.square_grid_2x2, size: 20)),
        Tab(icon: Icon(CupertinoIcons.bookmark, size: 20)),
      ],
    ).buildTabBar();
  }

}