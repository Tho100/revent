import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/themes/theme_color.dart';

class CustomAppBar {

  final String title;
  final Color? backgroundColor;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  final BuildContext? context;
  final VoidCallback? customBackOnPressed;
  final Widget? customLeading;
  final bool? enableCenter;
  final Color? leadingColor;

  const CustomAppBar({
    required this.context,
    required this.title,
    this.actions,
    this.bottom,
    this.backgroundColor,
    this.customBackOnPressed,
    this.customLeading,
    this.enableCenter,
    this.leadingColor,
  });

  PreferredSizeWidget? buildAppBar() {
    return AppBar(
      centerTitle: enableCenter ?? true,
      automaticallyImplyLeading: false,
      title: Text(
        title,
        style: GoogleFonts.inter(
          color: ThemeColor.white,
          fontWeight: FontWeight.w800,
          fontSize: 18
        )
      ),
      leading: customLeading ?? IconButton(
        icon: Icon(CupertinoIcons.chevron_back, color: leadingColor ?? ThemeColor.white),
        onPressed: customBackOnPressed ?? () => Navigator.pop(context!),
      ),
      backgroundColor: backgroundColor ?? ThemeColor.black,
      elevation: 0,
      actions: actions,
      bottom: bottom,
    );
  }

}