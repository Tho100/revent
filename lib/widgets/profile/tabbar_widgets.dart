import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:revent/widgets/custom_tab_bar.dart';
import 'package:revent/widgets/profile/my_posts_listview.dart';

class ProfileTabBarWidgets {

  BuildContext context;

  TabController controller;

  ProfileTabBarWidgets({
    required this.context,
    required this.controller
  });

  Widget _buildMyVentPostsTab() {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 28,
      child: const MyPostsListView(),
    );
  }

  Widget buildTabBarTabs() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5, 
      child: TabBarView(
        controller: controller,
        children: [
          _buildMyVentPostsTab(), 
          Container(),           
        ],
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