import 'package:flutter/material.dart';
import 'package:revent/widgets/custom_tab_bar.dart';
import 'package:revent/widgets/search/tabs/search_posts_listview.dart';

class SearchResultsTabBarWidgets {

  final TabController controller;

  final String searchText;

  SearchResultsTabBarWidgets({
    required this.controller,
    required this.searchText,
  });

  Widget buildTabBarTabs() {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 12.0),
      child: TabBarView(
        controller: controller,
        children: [

          const SearchPostsListView(),
          Container(),
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
        Tab(text: 'Posts'),
        Tab(text: 'Accounts'),
        Tab(text: 'Tags'),
      ],
    ).buildTabBar();
  }

}