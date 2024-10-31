import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:revent/widgets/custom_tab_bar.dart';
import 'package:revent/widgets/profile/profile_posts_listview.dart';

class ProfileTabBarWidgets {

  final BuildContext context;

  final TabController controller;

  ProfileTabBarWidgets({
    required this.context,
    required this.controller
  });

  Widget buildTabBarTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
      child: SizedBox( 
        height: MediaQuery.of(context).size.height * 1, 
        child: TabBarView(
          controller: controller,
          children: [
            const ProfilePostsListView(),
            Container(),
          ],
        ),
      ),
    );
  }

  Widget buildTabBar() {
    return Padding(
      padding: const EdgeInsets.only(top: 18.0),
      child: CustomTabBar(
        controller: controller, 
        tabAlignment: TabAlignment.fill,
        tabs: const [
          Tab(icon: Icon(CupertinoIcons.square_grid_2x2, size: 20)),
          Tab(icon: Icon(CupertinoIcons.bookmark, size: 20)),
        ],
      ).buildTabBar(),
    );
  }

}