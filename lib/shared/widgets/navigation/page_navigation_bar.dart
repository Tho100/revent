import 'package:flutter/material.dart';
import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/main.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/shared/widgets/bottomsheet_widgets/create.dart';
import 'package:revent/shared/widgets/navigation/navigation_bar_dock.dart';

class PageNavigationBar extends StatelessWidget {

  PageNavigationBar({super.key});

  final navigationIndex = getIt.navigationProvider;

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