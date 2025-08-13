import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:revent/global/alert_messages.dart';
import 'package:revent/global/app_keys.dart';
import 'package:revent/app/app_route.dart';
import 'package:revent/global/vent_type.dart';
import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/main.dart';
import 'package:revent/pages/authentication/sign_in.dart';
import 'package:revent/pages/authentication/sign_up.dart';
import 'package:revent/pages/vent/create_vent_page.dart';
import 'package:revent/pages/vent/edit_vent_page.dart';
import 'package:revent/pages/profile/follows_page.dart';
import 'package:revent/pages/home_page.dart';
import 'package:revent/pages/main_screen_page.dart';
import 'package:revent/pages/navigation/activity_page.dart';
import 'package:revent/pages/navigation/my_profile_page.dart';
import 'package:revent/pages/navigation/search_page.dart';
import 'package:revent/pages/setttings/settings_page.dart';
import 'package:revent/pages/profile/user_profile_page.dart';
import 'package:revent/service/activity_service.dart';
import 'package:revent/service/query/user/user_validator.dart';
import 'package:revent/service/query/user_profile/profile_picture_getter.dart';
import 'package:revent/shared/widgets/ui_dialog/snack_bar.dart';

class _DockBarNavigationPages {

  static void searchPage() {
    Navigator.push(
      AppKeys.navigatorKey.currentContext!,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const SearchPage(),
        transitionDuration: const Duration(microseconds: 0)
      ),
    );
  }

  static void activityPage() {
    Navigator.push(
      AppKeys.navigatorKey.currentContext!,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const ActivityPage(),
        transitionDuration: const Duration(microseconds: 0)
      ),
    );
  }

  static void myProfilePage() {
    Navigator.push(
      AppKeys.navigatorKey.currentContext!,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const MyProfilePage(),
        transitionDuration: const Duration(microseconds: 0)
      ),
    );
  }

}

class NavigatePage {

  static final _navigation = getIt.navigationProvider;

  static void mainScreenPage() {
    Navigator.pushReplacement(
      AppKeys.navigatorKey.currentContext!,
      MaterialPageRoute(
        builder: (_) => const MainScreenPage()
      ),
    );
  }

  static void homePage() {
    _navigation.setPageIndex(0);
    _navigation.setCurrentRoute(AppRoute.home);
    Navigator.pushAndRemoveUntil(
      AppKeys.navigatorKey.currentContext!,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const HomePage(), 
        transitionDuration: const Duration(microseconds: 0)
      ),
      (route) => false,
    );
  }

  static void searchPage() {
    _navigation.setPageIndex(1);
    _DockBarNavigationPages.searchPage();
  }

  static void activityPage() async {
    await ActivityService().initializeActivities().then((_) {
      _navigation.setPageIndex(3);
      _DockBarNavigationPages.activityPage();
    });
  }

  static void myProfilePage() {
    _navigation.setPageIndex(4);
    _navigation.setCurrentRoute(AppRoute.myProfile);
    _DockBarNavigationPages.myProfilePage();
  }

  static void _navigateToPage({required Widget classPage}) {
    Navigator.push(
      AppKeys.navigatorKey.currentContext!,
      MaterialPageRoute(
        builder: (_) => classPage
      )
    );
  }

  static void settingsPage() {
    _navigateToPage(
      classPage: const SettingsPage()
    );
  }

  static void createVentPage() {
    _navigateToPage(
      classPage: const CreateVentPage()
    );
  }

  static void followsPage({
    required String pageType, 
    required String username,
    required int totalFollowers,
    required int totalFollowing,
    bool isFollowingListHidden = false          
  }) {
    _navigateToPage(
      classPage: FollowsPage(
        pageType: pageType, 
        username: username, 
        totalFollowers: totalFollowers, 
        totalFollowing: totalFollowing, 
        isFollowingListHidden: isFollowingListHidden
      )
    );
  }

  static void signUpPage() {
    _navigateToPage(
      classPage: const SignUpPage()
    );
  }

  static void signInPage() {
    _navigateToPage(
      classPage: const SignInPage()
    );
  }

  static void userProfilePage({
    required String username, 
    Uint8List? pfpData
  }) async {

    username = username.replaceFirst('@', '');

    if (username == getIt.userProvider.user.username) {
      myProfilePage();
      return;
    }

    final userExists = await UserValidator().userExists(username: username);

    if (!userExists) {
      SnackBarDialog.errorSnack(message: AlertMessages.userNotFound);
      return;
    }

    final profilePicture = 
      pfpData ?? await ProfilePictureGetter().getProfilePictures(username: username);

    _navigation.setCurrentRoute(AppRoute.userProfile);

    _navigateToPage(
      classPage: UserProfilePage(
        username: username, 
        pfpData: profilePicture
      )
    );

  }
 
  static void editVentPage({
    required String title, 
    required String body,
    VentType ventType = VentType.nonArchived
  }) {
    _navigateToPage(
      classPage: EditVentPage(
        title: title, 
        body: body, 
        ventType: ventType
      )
    );
  }

}