import 'package:flutter/material.dart';
import 'package:revent/global/constant.dart';
import 'package:revent/pages/authentication/sign_in.dart';
import 'package:revent/pages/authentication/sign_up.dart';
import 'package:revent/pages/create_vent_page.dart';
import 'package:revent/pages/home_page.dart';
import 'package:revent/pages/main_screen_page.dart';
import 'package:revent/pages/navigations/notifications_page.dart';
import 'package:revent/pages/navigations/profile_page.dart';
import 'package:revent/pages/navigations/search_page.dart';
import 'package:revent/pages/setttings/settings_page.dart';

class NavigatePage {

  static void homePage() {
    Navigator.pushAndRemoveUntil(
      navigatorKey.currentContext!,
      PageRouteBuilder(pageBuilder: (_, __, ___) => const HomePage(), 
        transitionDuration: const Duration(microseconds: 0)
      ),
      (route) => false,
    );
  }

  static void mainScreenPage() {
    Navigator.pushReplacement(
      navigatorKey.currentContext!,
      MaterialPageRoute(builder: (context) => const MainScreenPage()),
    );
  }

  static void searchPage() {
    Navigator.push(
      navigatorKey.currentContext!,
      PageRouteBuilder(pageBuilder: (_, __, ___) => SearchPage(),
        transitionDuration: const Duration(microseconds: 0)
      ),
    );
  }

  static void notificationsPage() {
    Navigator.push(
      navigatorKey.currentContext!,
      PageRouteBuilder(pageBuilder: (_, __, ___) => NotificationsPage(),
        transitionDuration: const Duration(microseconds: 0)
      ),
    );
  }

  static void profilePage() {
    Navigator.push(
      navigatorKey.currentContext!,
      PageRouteBuilder(pageBuilder: (_, __, ___) => const ProfilePage(),
        transitionDuration: const Duration(microseconds: 0)
      ),
    );
  }

  static void settingsPage() {
    Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(builder: (context) => const SettingsPage()),
    );
  }

  static void createVentPage() {
    Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(builder: (context) => CreateVentPage()),
    );
  }

  static void createVentCommunityPage(BuildContext context) {
    
  }

  static void signUpPage() {
    Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(builder: (context) => const SignUpPage()),
    );
  }

  static void signInPage() {
    Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(builder: (context) => const SignInPage()),
    );
  }

}