import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:revent/global/constant.dart';
import 'package:revent/helper/app_route.dart';
import 'package:revent/pages/authentication/sign_in.dart';
import 'package:revent/pages/authentication/sign_up.dart';
import 'package:revent/pages/vent/create_vent_page.dart';
import 'package:revent/pages/vent/edit_vent_page.dart';
import 'package:revent/pages/profile/follows_page.dart';
import 'package:revent/pages/home_page.dart';
import 'package:revent/pages/main_screen_page.dart';
import 'package:revent/pages/navigation/notifications_page.dart';
import 'package:revent/pages/navigation/my_profile_page.dart';
import 'package:revent/pages/navigation/search_page.dart';
import 'package:revent/pages/setttings/settings_page.dart';
import 'package:revent/pages/profile/user_profile_page.dart';
import 'package:revent/pages/profile/view_full_bio_page.dart';
import 'package:revent/provider/navigation_provider.dart';
import 'package:revent/provider/user_data_provider.dart';

class _DockBarNavigationPages {

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

}

class NavigatePage {

  static final _navigation = GetIt.instance<NavigationProvider>();

  static void mainScreenPage() {
    Navigator.pushReplacement(
      navigatorKey.currentContext!,
      MaterialPageRoute(builder: (_) => const MainScreenPage()),
    );
  }

  static void homePage() {
    _navigation.setPageIndex(0);
    _navigation.setCurrentRoute(AppRoute.home);
    Navigator.pushAndRemoveUntil(
      navigatorKey.currentContext!,
      PageRouteBuilder(pageBuilder: (_, __, ___) => const HomePage(), 
        transitionDuration: const Duration(microseconds: 0)
      ),
      (route) => false,
    );
  }

  static void searchPage() {
    _navigation.setPageIndex(1);
    _DockBarNavigationPages.searchPage();
  }

  static void notificationsPage() {
    _navigation.setPageIndex(3);
    _DockBarNavigationPages.notificationsPage();
  }

  static void myProfilePage() {
    _navigation.setPageIndex(4);
    _navigation.setCurrentRoute(AppRoute.myProfile);
    _DockBarNavigationPages.myProfilePage();
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

  static void followsPage({
    required String pageType, 
    required String username
  }) {
    Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(builder: (_) => FollowsPage(pageType: pageType, username: username)),
    );
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

  static void userProfilePage({
    required String username, 
    required Uint8List pfpData
  }) {

    final userData = GetIt.instance<UserDataProvider>();

    if(username == userData.user.username) {
      myProfilePage();
      return;
    }

    _navigation.setCurrentRoute(AppRoute.userProfile);
    
    Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(builder: (_) => UserProfilePage(username: username, pfpData: pfpData))
    );

  }

  static void editVentPage({
    required String title, 
    required String body
  }) {
    Navigator.push(
      navigatorKey.currentContext!, 
      MaterialPageRoute(builder: (_) => EditVentPage(title: title, body: body))
    );
  }

  static void fullBioPage({required String bio}) {
    Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(builder: (_) => ViewFullBioPage(bio: bio)),
    );
  }

}