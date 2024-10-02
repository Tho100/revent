import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:revent/themes/theme_color.dart';

class NavigationBarDock extends StatelessWidget {

  final VoidCallback homeOnPressed;
  final VoidCallback searchOnPressed;
  final VoidCallback addOnPressed;
  final VoidCallback notificationOnPressed;
  final VoidCallback profileOnPressed;

  final int currentIndex;

  NavigationBarDock({
    required this.homeOnPressed, 
    required this.searchOnPressed,
    required this.addOnPressed, 
    required this.notificationOnPressed,
    required this.profileOnPressed,
    required this.currentIndex,
    Key? key
  }) : super(key: key);  
  

  final navIcons = [
    CupertinoIcons.home, 
    CupertinoIcons.search, 
    CupertinoIcons.add, 
    CupertinoIcons.bell,
    CupertinoIcons.person
  ];

  @override
  Widget build(BuildContext context) {

    final getNonAddIndex = currentIndex != 2 ? currentIndex : 2;
    final selectedNavigationIndexNotifier = ValueNotifier<int>(getNonAddIndex);

    return Container(
      height: 65,
      margin: const EdgeInsets.only(
        left: 25.5,
        right: 25.5,
        bottom: 24
      ),
      decoration: BoxDecoration(
        color: ThemeColor.darkGrey,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: navIcons.map((icon) {

          final index = navIcons.indexOf(icon);

          return Material(
            color: Colors.transparent,
            child: Column(
              children: [
                ValueListenableBuilder(
                  valueListenable: selectedNavigationIndexNotifier,
                  builder: (context, value, child) {

                    final isSelected = value == index;
                    final iconColor = index == 2
                      ? ThemeColor.thirdWhite
                      : (isSelected ? ThemeColor.secondaryWhite : ThemeColor.thirdWhite);

                    return Container(
                      alignment: Alignment.center, 
                      margin: const EdgeInsets.only(
                        top: 7.5, 
                        bottom: 0, 
                        left: 13.5, 
                        right: 13.5
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
        addOnPressed();
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