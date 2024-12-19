import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

    final getNonAddIndex = currentIndex == 2 ? 2 : currentIndex;
    final selectedNavigationIndexNotifier = ValueNotifier<int>(getNonAddIndex);

    return Container(
      height: 55.5,
      margin: const EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: 14
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: navIcons.map((icon) {

          final index = navIcons.indexOf(icon);

          return Material(
            color: Colors.transparent,
            child: Column(
              children: [

                ValueListenableBuilder(
                  valueListenable: selectedNavigationIndexNotifier,
                  builder: (_, value, __) {

                    final isSelected = value == index;
                    final iconColor = index == 2
                      ? ThemeColor.thirdWhite
                      : (isSelected ? ThemeColor.white : ThemeColor.thirdWhite);

                    return Container(
                      alignment: Alignment.center, 
                      margin: const EdgeInsets.only(
                        top: 7.5, 
                        bottom: 0, 
                        left: 12, 
                        right: 12
                      ),
                      child: IconButton(
                        icon: Icon(icon), 
                        color: iconColor, 
                        iconSize: 28,
                        onPressed: () {
                          if(index != 2) {
                            selectedNavigationIndexNotifier.value = index;
                          }
                          _buttonOnPressed(index);
                        }
                      ),
                    );
                  },
                ),

              ],
            ),
          );
        }).toList(),
      ),
    );
    
  }

  void _buttonOnPressed(int index) {
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