import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:revent/provider/navigation_provider.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/widgets/bottomsheet_widgets/create.dart';
import 'package:revent/widgets/navigation/navigation_bar_dock.dart';

class PageNavigationBar extends StatelessWidget {

  PageNavigationBar({super.key});

  final navigationIndex = GetIt.instance<NavigationProvider>();

  @override
  Widget build(BuildContext context) {
    return NavigationBarDock(
      homeOnPressed: () => NavigatePage.homePage(),
      searchOnPressed: () => NavigatePage.searchPage(),
      createOnPressed: () { 
        BottomsheetCreate().buildBottomsheet(
          context: context,
          addVentOnPressed: () {
            Navigator.pop(context);
            NavigatePage.createVentPage(); 
          }, 
          addForumOnPressed: () {
            Navigator.pop(context);
          },
        );
      },
      notificationOnPressed: () => NavigatePage.notificationsPage(),
      profileOnPressed: () => NavigatePage.myProfilePage(),
      currentIndex: navigationIndex.currentPageIndex,
    );
  }

}