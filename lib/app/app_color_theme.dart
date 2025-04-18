import 'package:flutter/material.dart';
import 'package:revent/shared/themes/theme_color.dart';

class AppColorTheme { // TODO: Move this to theme and rename to "Theme_Updater"

  final String theme;

  AppColorTheme({required this.theme});

  void updateTheme() {

    switch (theme) {

      case 'dark':

        ThemeColor.black = Colors.black;
        ThemeColor.mediumBlack = const Color.fromARGB(255, 12, 12, 12);

        ThemeColor.darkGrey = const Color.fromARGB(255, 17, 17, 17);
        ThemeColor.lightGrey = const Color.fromARGB(255, 35, 35, 35);

        ThemeColor.white = Colors.white;
        ThemeColor.secondaryWhite = const Color.fromARGB(255, 212, 212, 212);
        ThemeColor.thirdWhite = const Color.fromARGB(255, 117, 117, 117);
        ThemeColor.darkWhite = const Color.fromARGB(255, 75, 75, 75);

      case 'light':

        ThemeColor.black = Colors.white;
        ThemeColor.mediumBlack = const Color.fromARGB(255, 215, 215, 215);

        ThemeColor.darkGrey = const Color.fromARGB(255, 117, 117, 117);
        ThemeColor.lightGrey = const Color.fromARGB(255, 75, 75, 75);

        ThemeColor.white = Colors.black;
        ThemeColor.secondaryWhite = const Color.fromARGB(255, 15, 15, 15);
        ThemeColor.thirdWhite = const Color.fromARGB(255, 25, 25, 25);
        ThemeColor.darkWhite = const Color.fromARGB(255, 35, 35, 35);

    }

  }

}