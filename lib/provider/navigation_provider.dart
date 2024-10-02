import 'package:flutter/material.dart';

class NavigationProvider extends ChangeNotifier {
  
  int _pageIndex = 0;

  int get pageIndex => _pageIndex;

  void setPageIndex(int index) {
    _pageIndex = index;
    notifyListeners();
  }

}