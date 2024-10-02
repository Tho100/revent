import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/provider/navigation_provider.dart';
import 'package:revent/model/update_navigation.dart';
import 'package:revent/widgets/app_bar.dart';

class SearchPage extends StatelessWidget {

  SearchPage({super.key});

  final navigationIndex = GetIt.instance<NavigationProvider>();

  @override
  Widget build(BuildContext context) {
    navigationIndex.setPageIndex(1);
    return WillPopScope(
      onWillPop: () async {
        NavigatePage.homePage(context);
        return true;
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Search',
          customBackOnPressed: () => NavigatePage.homePage(context),
          context: context
        ).buildAppBar(),
        bottomNavigationBar: UpdateNavigation(
          context: context,
        ).showNavigationBar(),
      ),
    );
  }

}