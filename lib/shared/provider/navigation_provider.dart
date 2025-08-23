import 'package:flutter/material.dart';
import 'package:revent/app/app_route.dart';
import 'package:revent/global/tabs_type.dart';

class NavigationProvider extends ChangeNotifier {
  
  NavigationTabs _currentNavigation = NavigationTabs.home;

  HomeTabs _homeTab = HomeTabs.latest;
  ProfileTabs _profileTab = ProfileTabs.posts;

  AppRoute _currentRoute = AppRoute.home;

  bool _showActivityBadge = false;

  NavigationTabs get currentNavigation => _currentNavigation;
  HomeTabs get homeTab => _homeTab;
  ProfileTabs get profileTab => _profileTab;

  AppRoute get currentRoute => _currentRoute; 

  bool get showActivityBadge => _showActivityBadge; 

  void setCurrentRoute(AppRoute route) {
    _currentRoute = route;
  }

  void setPage(NavigationTabs tab) {
    _currentNavigation = tab;
  }

  void setHomeTab(HomeTabs tab) {
    _homeTab = tab;
  }
  
  void setProfileTab(ProfileTabs tab) {
    _profileTab = tab;
  }

  void setBadgeVisible(bool showBadge) {
    _showActivityBadge = showBadge;
    notifyListeners();
  }

}