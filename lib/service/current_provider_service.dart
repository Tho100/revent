import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:revent/app/app_route.dart';
import 'package:revent/global/type/tabs_type.dart';
import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/main.dart';
import 'package:revent/shared/provider/profile/posts_provider.dart';
import 'package:revent/shared/provider/profile/saved_provider.dart';
import 'package:revent/shared/provider/search/posts_provider.dart';
import 'package:revent/shared/provider/vent/liked_vent_provider.dart';
import 'package:revent/shared/provider/vent/saved_vent_provider.dart';
import 'package:revent/shared/provider/vent/feed/latest_provider.dart';
import 'package:revent/shared/provider/vent/feed/following_provider.dart';
import 'package:revent/shared/provider/vent/feed/trending_provider.dart';

class CurrentProviderService {

  final int? postId;

  CurrentProviderService({this.postId});

  final _navigation = getIt.navigationProvider;

  Map<String, dynamic> _resolveVentData({
    required dynamic ventData,
    required bool isProfileRoute,
  }) {

    int ventIndex = 0;

    if (isProfileRoute) {

      final profileData = _navigation.currentRoute == AppRoute.myProfile
        ? ventData.myProfile
        : ventData.userProfile;

      ventIndex = profileData.postIds.indexWhere(
        (currentPostId) => currentPostId == postId
      );

    } else {

      ventIndex = ventData.vents.indexWhere(
        (vent) => vent.postId == postId
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

    if (type == 'home') {

      if (_navigation.homeTab == HomeTabs.latest) {
        return realTime 
          ? Provider.of<VentLatestProvider>(context!) : getIt.ventLatestProvider;

      } else if (_navigation.homeTab == HomeTabs.trending) {
        return realTime 
          ? Provider.of<VentTrendingProvider>(context!) : getIt.ventTrendingProvider;
        
      } else if (_navigation.homeTab == HomeTabs.following) {
        return realTime 
          ? Provider.of<VentFollowingProvider>(context!) : getIt.ventFollowingProvider;

      }

    } else if (type == 'profile') {

      if (_navigation.profileTab == ProfileTabs.posts) {
        return realTime 
          ? Provider.of<ProfilePostsProvider>(context!) : getIt.profilePostsProvider;

      } else if (_navigation.profileTab == ProfileTabs.savedPosts) {
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

    if (_navigation.currentRoute == AppRoute.home) {
      ventData = _returnProvider(type: 'home', realTime: false);

    } else if (RouteHelper.isOnProfile) {
      ventData = _returnProvider(type: 'profile', realTime: false);

    } else if (_navigation.currentRoute == AppRoute.searchResults) {
      ventData = _returnProvider(type: 'search', realTime: false);

    } else if (_navigation.currentRoute == AppRoute.profileLikedPosts) {
      ventData = _returnProvider(type: 'liked', realTime: false);

    } else if (_navigation.currentRoute == AppRoute.profileSavedPosts) {
      ventData = _returnProvider(type: 'saved', realTime: false);

    }

    final isProfileRoute = RouteHelper.isOnProfile;

    return _resolveVentData(
      ventData: ventData, isProfileRoute: isProfileRoute
    );

  }

  Map<String, dynamic> getRealTimeProvider({required BuildContext context}) {

    dynamic ventData;

    if (_navigation.currentRoute == AppRoute.home) {
      ventData = _returnProvider(type: 'home', realTime: true, context: context);

    } else if (RouteHelper.isOnProfile) {
      ventData = _returnProvider(type: 'profile', realTime: true, context: context);

    } else if (_navigation.currentRoute == AppRoute.searchResults) {
      ventData = _returnProvider(type: 'search', realTime: true, context: context);

    } else if (_navigation.currentRoute == AppRoute.profileLikedPosts) {
      ventData = _returnProvider(type: 'liked', realTime: true, context: context);

    } else if (_navigation.currentRoute == AppRoute.profileSavedPosts) {
      ventData = _returnProvider(type: 'saved', realTime: true, context: context);

    }

    final isProfileRoute = RouteHelper.isOnProfile;

    return _resolveVentData(
      ventData: ventData, isProfileRoute: isProfileRoute
    );

  }

}