import 'package:flutter/material.dart';
import 'package:revent/app/app_route.dart';

class NavigationProvider extends ChangeNotifier {
  
  int _currentPageIndex = 0;
  int _homeTabIndex = 0;
  int _profileTabIndex = 0;

  String _currentRoute = AppRoute.home;

  int get currentPageIndex => _currentPageIndex;
  int get homeTabIndex => _homeTabIndex;
  int get profileTabIndex => _profileTabIndex;

  String get currentRoute => _currentRoute; 

  void setCurrentRoute(String route) {
    _currentRoute = route;
  }

  void setPageIndex(int index) {
    _currentPageIndex = index;
  }

  void setHomeTabIndex(int index) {
    _homeTabIndex = index;
  }
  
  void setProfileTabIndex(int index) {
    _profileTabIndex = index;
  }

}