import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/provider/navigation_provider.dart';
import 'package:revent/model/update_navigation.dart';
import 'package:revent/widgets/app_bar.dart';

class NotificationsPage extends StatelessWidget {

  NotificationsPage({super.key});

  final navigationIndex = GetIt.instance<NavigationProvider>();

  @override
  Widget build(BuildContext context) {
    navigationIndex.setPageIndex(3);
    return WillPopScope(
      onWillPop: () async {
        NavigatePage.homePage();
        return true;
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Notifications',
          customBackOnPressed: () => NavigatePage.homePage(),
          context: context
        ).buildAppBar(),
        bottomNavigationBar: UpdateNavigation(
          context: context,
        ).showNavigationBar(),
      ),
    );
  }

}