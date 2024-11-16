import 'package:flutter/material.dart';

class NavigationProvider extends ChangeNotifier {
  
  int _pageIndex = 0;
  int _activeTabIndex = 0;

  int get pageIndex => _pageIndex;
  int get activeTabIndex => _activeTabIndex;

  void setPageIndex(int index) {
    _pageIndex = index;
    notifyListeners();
  }

  void setTabIndex(int index) {
    _activeTabIndex = index;
    notifyListeners();
  }

}