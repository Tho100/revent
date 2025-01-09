import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:revent/global/constant.dart';
import 'package:revent/app/app_route.dart';
import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/main.dart';
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
import 'package:revent/service/query/user_profile/profile_picture_getter.dart';

class _DockBarNavigationPages {

  static void searchPage() {
    Navigator.push(
      navigatorKey.currentContext!,
      PageRouteBuilder(pageBuilder: (_, __, ___) => const SearchPage(),
        transitionDuration: const Duration(microseconds: 0)
      ),
    );
  }

  static void notificationsPage() {
    Navigator.push(
      navigatorKey.currentContext!,
      PageRouteBuilder(pageBuilder: (_, __, ___) => const NotificationsPage(),
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

  static final _navigation = getIt.navigationProvider;

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
    required String username,
    bool? isFollowingListHidden = false          
  }) {
    Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(builder: (_) => FollowsPage(
        pageType: pageType, username: username, isFollowingListHidden: isFollowingListHidden!
      )),
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
    Uint8List? pfpData
  }) async {

    final userData = getIt.userProvider; // TODO: Remove this

    if(username == userData.user.username) {
      myProfilePage();
      return;
    }

    _navigation.setCurrentRoute(AppRoute.userProfile);

    final profilePicture = 
      pfpData ?? await ProfilePictureGetter().getProfilePictures(username: username);

    Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(builder: (_) => UserProfilePage(username: username, pfpData: profilePicture))
    );

  }

  static void editVentPage({
    required String title, 
    required String body,
    bool? isArchive = false
  }) {
    Navigator.push(
      navigatorKey.currentContext!, 
      MaterialPageRoute(builder: (_) => EditVentPage(title: title, body: body, isArchive: isArchive!))
    );
  }

}