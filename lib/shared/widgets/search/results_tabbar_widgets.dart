import 'package:flutter/material.dart';
import 'package:revent/shared/widgets/custom_tab_bar.dart';
import 'package:revent/shared/widgets/search/tabs/search_accounts_listview.dart';
import 'package:revent/shared/widgets/search/tabs/search_posts_listview.dart';

class SearchResultsTabBarWidgets {

  final TabController controller;

  SearchResultsTabBarWidgets({required this.controller});

  Widget buildTabBarTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: TabBarView(
        controller: controller,
        children: const [SearchPostsListView(), SearchAccountsListView()]
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
      ],
    ).buildTabBar();
  }

}