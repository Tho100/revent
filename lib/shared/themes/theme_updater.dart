import 'package:flutter/material.dart';
import 'package:revent/shared/themes/theme_color.dart';

class ThemeUpdater {

  final String theme;

  ThemeUpdater({required this.theme});

  void updateTheme() {

    switch (theme) {

      case 'dark':

        ThemeColor.backgroundPrimary = Colors.black;
        ThemeColor.foregroundPrimary = const Color.fromARGB(255, 12, 12, 12);

        ThemeColor.divider = const Color.fromARGB(255, 35, 35, 35);
        ThemeColor.cursor = Colors.white;

        ThemeColor.contentPrimary = Colors.white;
        ThemeColor.contentSecondary = const Color.fromARGB(255, 212, 212, 212);
        ThemeColor.contentThird = const Color.fromARGB(255, 117, 117, 117);
        ThemeColor.trackSwitch = const Color.fromARGB(255, 75, 75, 75);

      case 'light':

        ThemeColor.backgroundPrimary = Colors.white;
        ThemeColor.foregroundPrimary = const Color.fromARGB(255, 215, 215, 215);

        ThemeColor.divider = const Color.fromARGB(255, 75, 75, 75);
        ThemeColor.cursor = Colors.black;

        ThemeColor.contentPrimary = Colors.black;
        ThemeColor.contentSecondary = const Color.fromARGB(255, 15, 15, 15);
        ThemeColor.contentThird = const Color.fromARGB(255, 25, 25, 25);
        ThemeColor.trackSwitch = const Color.fromARGB(255, 35, 35, 35);

      case 'gray':

        ThemeColor.backgroundPrimary = const Color.fromARGB(255, 98, 98, 98);
        ThemeColor.foregroundPrimary = const Color.fromARGB(255, 12, 12, 12);

        ThemeColor.divider = const Color.fromARGB(255, 142, 142, 142);
        ThemeColor.cursor = Colors.white;

        ThemeColor.contentPrimary = Colors.white;
        ThemeColor.contentSecondary = const Color.fromARGB(255, 212, 212, 212);
        ThemeColor.contentThird = const Color.fromARGB(255, 205, 205, 205);
        ThemeColor.trackSwitch = const Color.fromARGB(255, 44, 44, 44);
        ThemeColor.likedColor = const Color.fromARGB(255, 65, 65, 65);

      case 'pink':

        ThemeColor.backgroundPrimary = const Color.fromARGB(255, 244, 197, 213);
        ThemeColor.foregroundPrimary = const Color.fromARGB(255, 215, 215, 215);

        ThemeColor.divider = const Color.fromARGB(255, 253, 120, 164);
        ThemeColor.cursor = const Color.fromARGB(255, 255, 85, 142);

        ThemeColor.contentPrimary = Colors.black;
        ThemeColor.contentSecondary = const Color.fromARGB(255, 15, 15, 15);
        ThemeColor.contentThird = const Color.fromARGB(255, 25, 25, 25);
        ThemeColor.trackSwitch = const Color.fromARGB(255, 255, 85, 142);
        ThemeColor.likedColor = const Color.fromARGB(255, 255, 85, 142);

      case 'blue':

        ThemeColor.backgroundPrimary = const Color.fromARGB(255, 99, 135, 255);
        ThemeColor.foregroundPrimary = const Color.fromARGB(255, 215, 215, 215);

        ThemeColor.divider = const Color.fromARGB(255, 40, 48, 159);
        ThemeColor.cursor = const Color.fromARGB(255, 0, 10, 155);

        ThemeColor.contentPrimary = Colors.black;
        ThemeColor.contentSecondary = const Color.fromARGB(255, 15, 15, 15);
        ThemeColor.contentThird = const Color.fromARGB(255, 25, 25, 25);
        ThemeColor.trackSwitch = const Color.fromARGB(255, 0, 82, 183);
        ThemeColor.likedColor = const Color.fromARGB(255, 0, 82, 183);

      case 'green':

        ThemeColor.backgroundPrimary = const Color.fromARGB(255, 83, 232, 130);
        ThemeColor.foregroundPrimary = const Color.fromARGB(255, 215, 215, 215);

        ThemeColor.divider = const Color.fromARGB(255, 23, 104, 49);
        ThemeColor.cursor = const Color.fromARGB(255, 20, 86, 41);

        ThemeColor.contentPrimary = Colors.black;
        ThemeColor.contentSecondary = const Color.fromARGB(255, 15, 15, 15);
        ThemeColor.contentThird = const Color.fromARGB(255, 25, 25, 25);
        ThemeColor.trackSwitch = const Color.fromARGB(255, 27, 126, 58);
        ThemeColor.likedColor = const Color.fromARGB(255, 49, 166, 86);

    }

  }

}