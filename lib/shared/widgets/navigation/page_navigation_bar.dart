import 'package:flutter/material.dart';
import 'package:revent/helper/providers_service.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/shared/widgets/navigation/navigation_bar_dock.dart';

class PageNavigationBar extends StatelessWidget with NavigationProviderService {

  PageNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return NavigationBarDock(
      homeOnPressed: () => NavigatePage.homePage(),
      searchOnPressed: () => NavigatePage.searchPage(),
      createOnPressed: () => NavigatePage.createVentPage(),
      notificationOnPressed: () => NavigatePage.notificationsPage(),
      profileOnPressed: () => NavigatePage.myProfilePage(),
      currentIndex: navigationProvider.currentPageIndex,
    );
  }

}