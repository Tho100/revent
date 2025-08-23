import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revent/global/tabs_type.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/shared/provider/navigation_provider.dart';
import 'package:revent/shared/themes/theme_color.dart';

class NavigationBarDock extends StatelessWidget {

  NavigationBarDock({super.key});
  
  final _navigationIcons = {
    NavigationTabs.home: CupertinoIcons.home,
    NavigationTabs.search: CupertinoIcons.search,
    NavigationTabs.create: CupertinoIcons.add,
    NavigationTabs.activity: CupertinoIcons.heart,
    NavigationTabs.profile: CupertinoIcons.person,
  };

  final _navigationActions = {
    NavigationTabs.home: NavigatePage.homePage,
    NavigationTabs.search: NavigatePage.searchPage,
    NavigationTabs.create: NavigatePage.createVentPage,
    NavigationTabs.activity: NavigatePage.activityPage,
    NavigationTabs.profile: NavigatePage.myProfilePage,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: _navigationIcons.entries.map((entry) {

          final page = entry.key;
          final icon = entry.value;

          return Material(
            color: Colors.transparent,
            child: Consumer<NavigationProvider>(
              builder: (_, navigation, __) {

                final isSelected = navigation.currentNavigation == page;

                final iconColor = page == NavigationTabs.create
                  ? ThemeColor.contentThird
                  : (isSelected ? ThemeColor.contentPrimary : ThemeColor.contentThird);

                return Stack(
                  children: [

                    IconButton(
                      icon: Icon(icon),
                      color: iconColor,
                      iconSize: 28,
                      onPressed: () {
                        if (page != NavigationTabs.create) {
                          navigation.setPage(page);
                        }
                        _onNavigationButtonPressed(page);
                      },
                    ),

                    if (page == NavigationTabs.activity && navigation.showActivityBadge)
                    Positioned(
                      top: 9,
                      right: 8,
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: ThemeColor.backgroundPrimary,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: ThemeColor.alert,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    ),

                  ],
                );
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  void _onNavigationButtonPressed(NavigationTabs page) {
  
    final actions = _navigationActions[page];

    if (actions != null) {
      actions();
    }

  }

}