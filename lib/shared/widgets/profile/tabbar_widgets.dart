import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:revent/shared/widgets/custom_tab_bar.dart';
import 'package:revent/shared/widgets/profile/tabs/profile_posts_listview.dart';
import 'package:revent/shared/widgets/profile/tabs/profile_saved_listview.dart';

class ProfileTabBarWidgets {

  final TabController controller;
  
  final bool isMyProfile;
  final bool? isSavedHidden;

  final String username;
  final Uint8List pfpData;

  ProfileTabBarWidgets({
    required this.controller,
    required this.isMyProfile,
    required this.username,
    required this.pfpData,
    this.isSavedHidden = false
  });

  Widget buildTabBarTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: TabBarView(
        controller: controller,
        children: [

          ProfilePostsListView(
            isMyProfile: isMyProfile,
            username: username,
            pfpData: pfpData,
          ),

          ProfileSavedListView(
            isMyProfile: isMyProfile,
            isSavedHidden: isSavedHidden!,
          ),

        ],
      ),
    );
  }

  Widget buildTabBar() {
    return CustomTabBar(
      controller: controller, 
      tabAlignment: TabAlignment.fill,
      tabs: const [
        Tab(text: 'Vents'),
        Tab(text: 'Saved'),
      ],
    ).buildTabBar();
  }

}