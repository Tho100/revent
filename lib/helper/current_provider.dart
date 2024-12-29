import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:revent/app/app_route.dart';
import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/main.dart';
import 'package:revent/shared/provider/profile/profile_posts_provider.dart';
import 'package:revent/shared/provider/profile/profile_saved_provider.dart';
import 'package:revent/shared/provider/search/search_posts_provider.dart';
import 'package:revent/shared/provider/vent/liked_vent_provider.dart';
import 'package:revent/shared/provider/vent/saved_vent_provider.dart';
import 'package:revent/shared/provider/vent/vent_for_you_provider.dart';
import 'package:revent/shared/provider/vent/vent_following_provider.dart';
import 'package:revent/shared/provider/vent/vent_trending_provider.dart';

class CurrentProvider {

  final String? title;
  final String? creator;

  CurrentProvider({
    this.title,
    this.creator,
  });

  final navigation = getIt.navigationProvider;

  Map<String, dynamic> _resolveVentData({
    required dynamic ventData,
    required bool isProfileRoute,
  }) {

    int ventIndex = 0;

    if (isProfileRoute) {

      final profileData = navigation.currentRoute == AppRoute.myProfile
        ? ventData.myProfile
        : ventData.userProfile;

      ventIndex = profileData.titles.indexWhere(
        (ventTitle) => ventTitle == title,
      );

    } else {

      ventIndex = ventData.vents.indexWhere(
        (vent) => vent.title == title && vent.creator == creator,
      );

    }

    return {
      'vent_index': ventIndex,
      'vent_data': ventData,
    };

  }

  dynamic _returnProvider({
    required String type,
    required bool realTime,
    BuildContext? context
  }) {

    if(type == 'home') {

      if(navigation.homeTabIndex == 0) {
        return realTime 
          ? Provider.of<VentForYouProvider>(context!) : getIt.ventForYouProvider;

      } else if (navigation.homeTabIndex == 1) {
        return realTime 
          ? Provider.of<VentTrendingProvider>(context!) : getIt.ventTrendingProvider;
        
      } else if (navigation.homeTabIndex == 2) {
        return realTime 
          ? Provider.of<VentFollowingProvider>(context!) : getIt.ventFollowingProvider;

      }

    } else if (type == 'profile') {

      if(navigation.profileTabIndex == 0) {
        return realTime 
          ? Provider.of<ProfilePostsProvider>(context!) : getIt.profilePostsProvider;

      } else if (navigation.profileTabIndex == 1) {
        return realTime 
          ? Provider.of<ProfileSavedProvider>(context!) : getIt.profileSavedProvider;

      }

    } else if (type == 'search') {
      return realTime 
        ? Provider.of<SearchPostsProvider>(context!) : getIt.searchPostsProvider;
        
    } else if (type == 'liked') {
      return realTime 
        ? Provider.of<LikedVentProvider>(context!) : getIt.likedVentProvider;

    } else if (type == 'saved') {
      return realTime 
        ? Provider.of<SavedVentProvider>(context!) : getIt.savedVentProvider;

    }

  }

  Map<String, dynamic> getProvider() {

    dynamic ventData;

    if(navigation.currentRoute == AppRoute.home) {
      ventData = _returnProvider(type: 'home', realTime: false);

    } else if (AppRoute.isOnProfile) {
      ventData = _returnProvider(type: 'profile', realTime: false);

    } else if (navigation.currentRoute == AppRoute.searchResults) {
      ventData = _returnProvider(type: 'search', realTime: false);

    } else if (navigation.currentRoute == AppRoute.likedPosts) {
      ventData = _returnProvider(type: 'liked', realTime: false);

    } else if (navigation.currentRoute == AppRoute.savedPosts) {
      ventData = _returnProvider(type: 'saved', realTime: false);

    }

    final isProfileRoute = AppRoute.isOnProfile;

    return _resolveVentData(
      ventData: ventData, isProfileRoute: isProfileRoute
    );

  }

  Map<String, dynamic> getRealTimeProvider({required BuildContext context}) {

    dynamic ventData;

    if(navigation.currentRoute == AppRoute.home) {
      ventData = _returnProvider(type: 'home', realTime: true, context: context);

    } else if (AppRoute.isOnProfile) {
      ventData = _returnProvider(type: 'profile', realTime: true, context: context);

    } else if (navigation.currentRoute == AppRoute.searchResults) {
      ventData = _returnProvider(type: 'search', realTime: true, context: context);

    } else if (navigation.currentRoute == AppRoute.likedPosts) {
      ventData = _returnProvider(type: 'liked', realTime: true, context: context);

    } else if (navigation.currentRoute == AppRoute.savedPosts) {
      ventData = _returnProvider(type: 'saved', realTime: true, context: context);

    }

    final isProfileRoute = AppRoute.isOnProfile;

    return _resolveVentData(
      ventData: ventData, isProfileRoute: isProfileRoute
    );

  }

}