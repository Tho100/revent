import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:revent/provider/navigation_provider.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/model/create_new_item.dart';
import 'package:revent/widgets/bottomsheet_widgets/add_item.dart';
import 'package:revent/widgets/navigation_bar_dock.dart';

class UpdateNavigation {

  final BuildContext context;

  UpdateNavigation({
    required this.context,
  });

  final navigationIndex = GetIt.instance<NavigationProvider>();

  Widget showNavigationBar() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: NavigationBarDock(
        homeOnPressed: () => NavigatePage.homePage(context),
        searchOnPressed: () => NavigatePage.searchPage(context),
        addOnPressed: () { 
          BottomsheetAddItem().buildBottomsheet(
            context: context,
            addVentOnPressed: () {
              Navigator.pop(context);
              NavigatePage.createVentPage(context); 
            }, 
            addForumOnPressed: () {
              Navigator.pop(context);
              CreateNewItem().newForum();
            },
          );
        },
        notificationOnPressed: () => NavigatePage.notificationsPage(context),
        profileOnPressed: () => NavigatePage.profilePage(context),
        currentIndex: navigationIndex.pageIndex,
      ),
    );
  }

}