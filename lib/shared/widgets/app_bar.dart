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
  final Widget? titleWidget;
  final Widget? customLeading;
  final bool? enableCenter;
  final Color? leadingColor;
  final VoidCallback? customBackOnPressed;

  const CustomAppBar({
    required this.context,
    this.titleWidget,
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
      title: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: titleWidget ?? Text(
          title ?? '',
          style: GoogleFonts.inter(
            color: ThemeColor.contentPrimary,
            fontWeight: FontWeight.w800,
            fontSize: 18
          )
        ),
      ),
      leading: customLeading ?? IconButton(
        icon: Icon(CupertinoIcons.chevron_back, color: leadingColor ?? ThemeColor.contentPrimary),
        onPressed: customBackOnPressed ?? () => Navigator.pop(context!),
      ),
      backgroundColor: backgroundColor ?? ThemeColor.backgroundPrimary,
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
        padding: const EdgeInsets.only(left: 20.0, top: 16.0),
        child: Text(
          title ?? '',
          style: GoogleFonts.inter(
            color: ThemeColor.contentPrimary,
            fontWeight: FontWeight.w800,
            fontSize: 26,
          ),
        ),
      ),
      backgroundColor: backgroundColor ?? ThemeColor.backgroundPrimary,
      elevation: 0,
      actions: actions,
      bottom: bottom,
    );
  }

}