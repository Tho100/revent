import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/shared/themes/theme_color.dart';

class CustomTabBar {

  final TabController controller;
  final List<Widget> tabs;

  final TabAlignment? tabAlignment;

  CustomTabBar({
    required this.controller,
    required this.tabs,
    required this.tabAlignment
  });

  PreferredSizeWidget buildTabBar() {
    return TabBar(
      tabAlignment: tabAlignment,
      controller: controller,
      labelColor: ThemeColor.contentPrimary,              
      unselectedLabelColor: ThemeColor.contentThird,      
      indicator: UnderlineTabIndicator(
        borderRadius: BorderRadius.circular(36),
        borderSide: BorderSide(width: 2.5, color: ThemeColor.contentPrimary),
        insets: const EdgeInsets.symmetric(horizontal: 25), 
      ),
      labelStyle: GoogleFonts.inter(             
        fontSize: 14,
        fontWeight: FontWeight.w800,
      ),
      unselectedLabelStyle: GoogleFonts.inter(   
        fontSize: 14,
        fontWeight: FontWeight.w800,        
      ),
      tabs: tabs
    );
  }

}