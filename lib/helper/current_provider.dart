import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:revent/helper/app_route.dart';
import 'package:revent/provider/navigation_provider.dart';
import 'package:revent/provider/profile/profile_posts_provider.dart';
import 'package:revent/provider/profile/profile_saved_provider.dart';
import 'package:revent/provider/vent/vent_data_provider.dart';
import 'package:revent/provider/vent/vent_following_data_provider.dart';

class CurrentProvider {

  final String? title;
  final String? creator;

  CurrentProvider({
    this.title,
    this.creator,
  });

  final navigation = GetIt.instance<NavigationProvider>();

  // TODO: simplify codebase

  dynamic getProviderOnly() {

    dynamic ventData;

    if(navigation.currentRoute == AppRoute.home) {

      if(navigation.homeTabIndex == 0) {
        ventData = GetIt.instance<VentDataProvider>();

      } else if (navigation.homeTabIndex == 1) {
        ventData = GetIt.instance<VentFollowingDataProvider>();

      }

    } else if (navigation.currentRoute == AppRoute.myProfile || navigation.currentRoute == AppRoute.userProfile) {

      if(navigation.profileTabIndex == 0) {
        ventData = GetIt.instance<ProfilePostsProvider>();

      } else if (navigation.profileTabIndex == 1) {
        ventData = GetIt.instance<ProfileSavedProvider>();

      }

    } 

    return ventData;

  }

  Map<String, dynamic> getProvider() {

    dynamic ventData;

    int index = 0;

    if(navigation.currentRoute == '/home/') {

      if(navigation.homeTabIndex == 0) {
        ventData = GetIt.instance<VentDataProvider>();

      } else if (navigation.homeTabIndex == 1) {
        ventData = GetIt.instance<VentFollowingDataProvider>();

      }

      index = ventData.vents.indexWhere(
        (vent) => vent.title == title && vent.creator == creator
      );

    } else if (navigation.currentRoute == '/profile/my_profile/' || navigation.currentRoute == '/profile/user_profile/') {

      if(navigation.profileTabIndex == 0) {
        ventData = GetIt.instance<ProfilePostsProvider>();

      } else if (navigation.profileTabIndex == 1) {
        ventData = GetIt.instance<ProfileSavedProvider>();

      }

      final profileData = navigation.currentRoute == '/profile/my_profile/' 
        ? ventData.myProfile : ventData.userProfile;

      index = profileData.titles.indexWhere(
        (ventTitle) => ventTitle == title
      );

    } 

    return {
      'vent_index': index,
      'vent_data': ventData
    };

  }

  Map<String, dynamic> getRealTimeProvider({required BuildContext context}) {

    dynamic ventData;

    int index = 0;

    if(navigation.currentRoute == '/home/') {

      if(navigation.homeTabIndex == 0) {
        ventData = Provider.of<VentDataProvider>(context);

      } else if (navigation.homeTabIndex == 1) {
        ventData = Provider.of<VentFollowingDataProvider>(context);

      }

      index = ventData.vents.indexWhere(
        (vent) => vent.title == title && vent.creator == creator
      );

    } else if (navigation.currentRoute == '/profile/my_profile/' || navigation.currentRoute == '/profile/user_profile/') {

      if(navigation.profileTabIndex == 0) {
        ventData = Provider.of<ProfilePostsProvider>(context);

      } else if (navigation.profileTabIndex == 1) {
        ventData = Provider.of<ProfileSavedProvider>(context);

      }

      final profileData = navigation.currentRoute == '/profile/my_profile/' 
        ? ventData.myProfile : ventData.userProfile;

      index = profileData.titles.indexWhere(
        (ventTitle) => ventTitle == title
      );

    } 

    return {
      'vent_index': index,
      'vent_data': ventData
    };

  }

}