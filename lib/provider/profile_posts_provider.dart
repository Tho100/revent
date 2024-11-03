import 'package:flutter/material.dart';

class ProfilePostsProvider extends ChangeNotifier {

  List<String> _myProfileTitles = [];
  List<String> _userProfileTitles = [];

  List<int> _myProfileTotalLikes = [];
  List<int> _userProfileTotalLikes = [];

  List<String> get myProfileTitles => _myProfileTitles;
  List<String> get userProfileTitles => _userProfileTitles;

  List<int> get myProfileTotalLikes => _myProfileTotalLikes;
  List<int> get userProfileTotalLikes => _userProfileTotalLikes;

  void setMyProfileTitles(List<String> titles) {
    _myProfileTitles = titles;
    notifyListeners();
  }

  void setUserProfileTitles(List<String> titles) {
    _userProfileTitles = titles;
    notifyListeners();
  }

  void setMyProfileTotalLikes(List<int> totalLikes) {
    _myProfileTotalLikes = totalLikes;
    notifyListeners();
  }

  void setUserProfileTotalLikes(List<int> totalLikes) {
    _userProfileTotalLikes = totalLikes;
    notifyListeners();
  }

  void clearPostsData() {
    _myProfileTitles.clear();
    _userProfileTitles.clear();
    notifyListeners();
  }

}