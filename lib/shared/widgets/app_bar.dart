import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/shared/themes/theme_color.dart';

class CustomAppBar {

  final BuildContext? context;
  final String? title;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  final Color? backgroundColor;
  final Widget? customLeading;
  final bool? enableCenter;
  final Color? leadingColor;
  final VoidCallback? customBackOnPressed;

  const CustomAppBar({
    required this.context,
    this.title,
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
        title ?? '',
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

  PreferredSizeWidget? buildNavigationAppBar() {
    return AppBar(
      leadingWidth: 250,
      automaticallyImplyLeading: false,
      leading: Padding(
        padding: const EdgeInsets.only(left: 20.0, top: 10.0),
        child: Text(
          title ?? '',
          style: GoogleFonts.inter(
            color: ThemeColor.white,
            fontWeight: FontWeight.w800,
            fontSize: 26,
          ),
        ),
      ),
      backgroundColor: backgroundColor ?? ThemeColor.black,
      elevation: 0,
      actions: actions,
      bottom: bottom,
    );
  }

}