import 'package:flutter/material.dart';
import 'package:revent/pages/create_vent_page.dart';
import 'package:revent/pages/home_page.dart';
import 'package:revent/pages/navigations/notifications_page.dart';
import 'package:revent/pages/navigations/profile_page.dart';
import 'package:revent/pages/navigations/search_page.dart';
import 'package:revent/pages/setttings/settings_page.dart';

class NavigatePage {

  static void homePage(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(pageBuilder: (_, __, ___) => const HomePage(), 
        transitionDuration: const Duration(microseconds: 0)
      ),
      (route) => false,
    );
  }

  static void searchPage(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(pageBuilder: (_, __, ___) => SearchPage(),
        transitionDuration: const Duration(microseconds: 0)
      ),
    );
  }

  static void notificationsPage(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(pageBuilder: (_, __, ___) => NotificationsPage(),
        transitionDuration: const Duration(microseconds: 0)
      ),
    );
  }

  static void profilePage(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(pageBuilder: (_, __, ___) => ProfilePage(),
        transitionDuration: const Duration(microseconds: 0)
      ),
    );
  }

  static void settingsPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsPage()),
    );
  }

  static void createVentPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateVentPage()),
    );
  }

}