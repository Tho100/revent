import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:revent/shared/themes/theme_color.dart';

class GlobalAppTheme {

  ThemeData buildAppTheme() {
    return ThemeData(
      actionIconTheme: ActionIconThemeData(
        backButtonIconBuilder: (_) => const Icon(CupertinoIcons.chevron_back),
      ),
      scaffoldBackgroundColor: ThemeColor.backgroundPrimary,
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: ThemeColor.backgroundPrimary,
      ),
    );
  }

}