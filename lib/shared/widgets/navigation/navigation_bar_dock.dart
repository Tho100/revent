import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revent/shared/provider/navigation_provider.dart';
import 'package:revent/shared/themes/theme_color.dart';

class NavigationBarDock extends StatelessWidget {

  final VoidCallback homeOnPressed;
  final VoidCallback searchOnPressed;
  final VoidCallback createOnPressed;
  final VoidCallback notificationOnPressed;
  final VoidCallback profileOnPressed;

  final int currentIndex;

  NavigationBarDock({
    required this.homeOnPressed, 
    required this.searchOnPressed,
    required this.createOnPressed, 
    required this.notificationOnPressed,
    required this.profileOnPressed,
    required this.currentIndex,
    super.key
  });
  
  final navIcons = [
    CupertinoIcons.home, 
    CupertinoIcons.search, 
    CupertinoIcons.add, 
    CupertinoIcons.bell,
    CupertinoIcons.person
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: navIcons.asMap().entries.map((entry) {

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

                    if (index == 3 && navigation.showNotificationBadge)
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
    switch (index) {
      case 0:
        homeOnPressed();
        break;
      case 1:
        searchOnPressed();
        break;
      case 2:
        createOnPressed();
        break;
      case 3:
        notificationOnPressed();
        break;
      case 4:
        profileOnPressed();
        break;
    }
  }

}