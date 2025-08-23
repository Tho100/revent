import 'package:flutter/material.dart';
import 'package:revent/app/app_route.dart';
import 'package:revent/global/tabs_type.dart';

class NavigationProvider extends ChangeNotifier {
  
  int _currentPageIndex = 0;

  HomeTabs _homeTab = HomeTabs.latest;
  ProfileTabs _profileTab = ProfileTabs.posts;

  AppRoute _currentRoute = AppRoute.home;

  bool _showActivityBadge = false;

  int get currentPageIndex => _currentPageIndex;
  HomeTabs get homeTab => _homeTab;
  ProfileTabs get profileTab => _profileTab;

  AppRoute get currentRoute => _currentRoute; 

  bool get showActivityBadge => _showActivityBadge; 

  void setCurrentRoute(AppRoute route) {
    _currentRoute = route;
  }

  void setPageIndex(int index) {
    _currentPageIndex = index;
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