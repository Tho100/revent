import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/themes/theme_color.dart';

class CustomTabBar {

  final TabController controller;
  final List<Widget> tabs;

  CustomTabBar({
    required this.controller,
    required this.tabs,
  });

  PreferredSizeWidget buildTabBar() {
    return TabBar(
      tabAlignment: TabAlignment.center,
      controller: controller,
      labelColor: ThemeColor.white,              
      unselectedLabelColor: Colors.grey,      
      indicator: UnderlineTabIndicator(
        borderRadius: BorderRadius.circular(36),
        borderSide: const BorderSide(width: 2.5, color: ThemeColor.white),
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