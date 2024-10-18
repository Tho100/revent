import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:revent/provider/navigation_provider.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/widgets/bottomsheet_widgets/create.dart';
import 'package:revent/widgets/navigation_bar_dock.dart';

class UpdateNavigation {

  final BuildContext context;

  UpdateNavigation({required this.context});

  final navigationIndex = GetIt.instance<NavigationProvider>();

  Widget showNavigationBar() {
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
            NavigatePage.createVentCommunityPage();
          },
        );
      },
      notificationOnPressed: () => NavigatePage.notificationsPage(),
      profileOnPressed: () => NavigatePage.myProfilePage(),
      currentIndex: navigationIndex.pageIndex,
    );
  }

}