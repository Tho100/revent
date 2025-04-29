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

        ThemeColor.contentPrimary = Colors.white;
        ThemeColor.contentSecondary = const Color.fromARGB(255, 212, 212, 212);
        ThemeColor.contentThird = const Color.fromARGB(255, 117, 117, 117);
        ThemeColor.trackSwitch = const Color.fromARGB(255, 75, 75, 75);

      case 'light':

        ThemeColor.backgroundPrimary = Colors.white;
        ThemeColor.foregroundPrimary = const Color.fromARGB(255, 215, 215, 215);

        ThemeColor.divider = const Color.fromARGB(255, 75, 75, 75);

        ThemeColor.contentPrimary = Colors.black;
        ThemeColor.contentSecondary = const Color.fromARGB(255, 15, 15, 15);
        ThemeColor.contentThird = const Color.fromARGB(255, 25, 25, 25);
        ThemeColor.trackSwitch = const Color.fromARGB(255, 35, 35, 35);

    }

  }

}