import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/shared/provider/navigation_provider.dart';
import 'package:revent/shared/themes/theme_color.dart';

class NavigationBarDock extends StatelessWidget {

  NavigationBarDock({super.key});
  
  final _navigationIcons = [
    CupertinoIcons.home, 
    CupertinoIcons.search, 
    CupertinoIcons.add, 
    CupertinoIcons.heart,
    CupertinoIcons.person
  ];

  final _navigationActions = [
    NavigatePage.homePage,
    NavigatePage.searchPage,
    NavigatePage.createVentPage,
    NavigatePage.activityPage,
    NavigatePage.myProfilePage,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: _navigationIcons.asMap().entries.map((entry) {

          final index = entry.key;
          final icon = entry.value;

          return Material(
            color: Colors.transparent,
            child: Consumer<NavigationProvider>(
              builder: (_, navigation, __) {

                final currentIndex = navigation.currentPageIndex;

                final isSelected = currentIndex == index;

                final iconColor = index == 2
                  ? ThemeColor.contentThird
                  : (isSelected ? ThemeColor.contentPrimary : ThemeColor.contentThird);

                return Stack(
                  children: [

                    IconButton(
                      icon: Icon(icon),
                      color: iconColor,
                      iconSize: 28,
                      onPressed: () {
                        if (index != 2) {
                          navigation.setPageIndex(index);
                        }
                        _onNavigationButtonPressed(index);
                      },
                    ),

                    if (index == 3 && navigation.showActivityBadge)
                    Positioned(
                      top: 9,
                      right: 12,
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

  void _onNavigationButtonPressed(int index) {
    if (index >= 0 && index < _navigationActions.length) {
      _navigationActions[index]();
    }
  }

}