import 'package:flutter/material.dart';

class NavigationProvider extends ChangeNotifier {
  
  int _currentPageIndex = 0;
  int _homeTabIndex = 0;
  int _profileTabIndex = 0;

  int get currentPageIndex => _currentPageIndex;
  int get homeTabIndex => _homeTabIndex;
  int get profileTabIndex => _profileTabIndex;

  void setPageIndex(int index) {
    _currentPageIndex = index;
    notifyListeners();
  }

  void setHomeTabIndex(int index) {
    _homeTabIndex = index;
    notifyListeners();
  }
  
  void setProfileTabIndex(int index) {
    _profileTabIndex = index;
    notifyListeners();
  }

}