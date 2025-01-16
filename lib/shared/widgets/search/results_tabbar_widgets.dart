import 'package:flutter/material.dart';
import 'package:revent/shared/widgets/custom_tab_bar.dart';
import 'package:revent/shared/widgets/search/tabs/search_accounts_listview.dart';
import 'package:revent/shared/widgets/search/tabs/search_posts_listview.dart';

class SearchResultsTabBarWidgets {

  final TabController controller;

  final String searchText;

  SearchResultsTabBarWidgets({
    required this.controller,
    required this.searchText,
  });

  Widget buildTabBarTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: TabBarView(
        controller: controller,
        children: [

          const SearchPostsListView(),
          const SearchAccountsListView(),
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