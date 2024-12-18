import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:revent/app/app_route.dart';
import 'package:revent/shared/provider/navigation_provider.dart';
import 'package:revent/shared/provider/profile/profile_posts_provider.dart';
import 'package:revent/shared/provider/profile/profile_saved_provider.dart';
import 'package:revent/shared/provider/search/search_posts_provider.dart';
import 'package:revent/shared/provider/vent/liked_vent_data_provider.dart';
import 'package:revent/shared/provider/vent/vent_for_you_provider.dart';
import 'package:revent/shared/provider/vent/vent_following_provider.dart';

class CurrentProvider {

  final String? title;
  final String? creator;

  CurrentProvider({
    this.title,
    this.creator,
  });

  final navigation = GetIt.instance<NavigationProvider>();

  dynamic _returnHomeProvider({
    required bool realTime, 
    BuildContext? context
  }) {

    if(navigation.homeTabIndex == 0) {
      return realTime 
        ? Provider.of<VentForYouProvider>(context!) : GetIt.instance<VentForYouProvider>();

    } else if (navigation.homeTabIndex == 1) {
      return realTime 
        ? Provider.of<VentFollowingProvider>(context!) : GetIt.instance<VentFollowingProvider>();

    }

  }

  dynamic _returnProfileProvider({
    required bool realTime, 
    BuildContext? context
  }) {

    if(navigation.profileTabIndex == 0) {
      return realTime 
        ? Provider.of<ProfilePostsProvider>(context!) : GetIt.instance<ProfilePostsProvider>();

    } else if (navigation.profileTabIndex == 1) {
      return realTime 
        ? Provider.of<ProfileSavedProvider>(context!) : GetIt.instance<ProfileSavedProvider>();

    }

  }

  dynamic _returnSearchProvider({
    required bool realTime, 
    BuildContext? context
  }) {
    return realTime 
      ? Provider.of<SearchPostsProvider>(context!) : GetIt.instance<SearchPostsProvider>();
  }

  dynamic _returnLikedPostsProvider({
    required bool realTime, 
    BuildContext? context
  }) {
    return realTime 
      ? Provider.of<LikedVentProvider>(context!) : GetIt.instance<LikedVentProvider>();
  }

  dynamic getProviderOnly() {

    if(navigation.currentRoute == AppRoute.home) {
      return _returnHomeProvider(realTime: false);

    } else if (AppRoute.isOnProfile) {
      return _returnProfileProvider(realTime: false);
      
    } else if (navigation.currentRoute == AppRoute.searchResults) {
      return _returnSearchProvider(realTime: false);

    }

  }

  Map<String, dynamic> getProvider() {

    dynamic ventData;

    int ventIndex = 0;

    if(navigation.currentRoute == AppRoute.home) {

      ventData = _returnHomeProvider(realTime: false);

      ventIndex = ventData.vents.indexWhere(
        (vent) => vent.title == title && vent.creator == creator
      );

    } else if (AppRoute.isOnProfile) {

      ventData = _returnProfileProvider(realTime: false);

      final profileData = navigation.currentRoute == AppRoute.myProfile
        ? ventData.myProfile : ventData.userProfile;

      ventIndex = profileData.titles.indexWhere(
        (ventTitle) => ventTitle == title
      );

    } else if (navigation.currentRoute == AppRoute.searchResults) {

      ventData = _returnSearchProvider(realTime: false);

      ventIndex = ventData.vents.indexWhere(
        (vent) => vent.title == title && vent.creator == creator
      );

    } else if (navigation.currentRoute == AppRoute.likedPosts) {

      ventData = _returnLikedPostsProvider(realTime: false);

      ventIndex = ventData.vents.indexWhere(
        (vent) => vent.title == title && vent.creator == creator
      );

    }

    return {
      'vent_index': ventIndex,
      'vent_data': ventData
    };

  }

  Map<String, dynamic> getRealTimeProvider({required BuildContext context}) {

    dynamic ventData;

    int ventIndex = 0;

    if(navigation.currentRoute == AppRoute.home) {

      ventData = _returnHomeProvider(realTime: true, context: context);

      ventIndex = ventData.vents.indexWhere(
        (vent) => vent.title == title && vent.creator == creator
      );

    } else if (AppRoute.isOnProfile) {

      ventData = _returnProfileProvider(realTime: true, context: context);

      final profileData = navigation.currentRoute == AppRoute.myProfile
        ? ventData.myProfile : ventData.userProfile;

      ventIndex = profileData.titles.indexWhere(
        (ventTitle) => ventTitle == title
      );

    } else if (navigation.currentRoute == AppRoute.searchResults) {

      ventData = _returnSearchProvider(realTime: true, context: context);

      ventIndex = ventData.vents.indexWhere(
        (vent) => vent.title == title && vent.creator == creator
      );

    } else if (navigation.currentRoute == AppRoute.likedPosts) {

      ventData = _returnLikedPostsProvider(realTime: true, context: context);

      ventIndex = ventData.vents.indexWhere(
        (vent) => vent.title == title && vent.creator == creator
      );

    }

    return {
      'vent_index': ventIndex,
      'vent_data': ventData
    };

  }

}