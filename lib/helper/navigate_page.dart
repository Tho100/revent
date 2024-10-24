import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:revent/global/constant.dart';
import 'package:revent/pages/authentication/sign_in.dart';
import 'package:revent/pages/authentication/sign_up.dart';
import 'package:revent/pages/create_vent_page.dart';
import 'package:revent/pages/home_page.dart';
import 'package:revent/pages/main_screen_page.dart';
import 'package:revent/pages/navigations/notifications_page.dart';
import 'package:revent/pages/navigations/my_profile_page.dart';
import 'package:revent/pages/navigations/search_page.dart';
import 'package:revent/pages/setttings/settings_page.dart';
import 'package:revent/pages/user_profile_page.dart';
import 'package:revent/provider/user_data_provider.dart';

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
      MaterialPageRoute(builder: (_) => const MainScreenPage()),
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

  static void myProfilePage() {
    Navigator.push(
      navigatorKey.currentContext!,
      PageRouteBuilder(pageBuilder: (_, __, ___) => const MyProfilePage(),
        transitionDuration: const Duration(microseconds: 0)
      ),
    );
  }

  static void settingsPage() {
    Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(builder: (_) => const SettingsPage()),
    );
  }

  static void createVentPage() {
    Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(builder: (_) => const CreateVentPage()),
    );
  }

  static void createVentCommunityPage() {
    
  }

  static void signUpPage() {
    Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(builder: (_) => const SignUpPage()),
    );
  }

  static void signInPage() {
    Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(builder: (_) => const SignInPage()),
    );
  }

  static void userProfilePage({required String username, required Uint8List pfpData}) {

    final userData = GetIt.instance<UserDataProvider>();

    if(username != userData.user.username) {
      Navigator.push(
        navigatorKey.currentContext!,
        MaterialPageRoute(builder: (context) => UserProfilePage(
          username: username, pfpData: pfpData
          )
        )
      ); 

    } else {
      myProfilePage();

    }

  }

}