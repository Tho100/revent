import 'package:flutter/material.dart';

class ProfilePostsProvider extends ChangeNotifier {

  List<String> _myProfileTitles = [];
  List<String> _userProfileTitles = [];

  List<String> get myProfileTitles => _myProfileTitles;
  List<String> get userProfileTitles => _userProfileTitles;

  void setMyProfileTitles(List<String> titles) {
    _myProfileTitles = titles;
    notifyListeners();
  }

  void setUserProfileTitles(List<String> titles) {
    _userProfileTitles = titles;
    notifyListeners();
  }

  void clearPostsData() {
    _myProfileTitles.clear();
    _userProfileTitles.clear();
    notifyListeners();
  }

}