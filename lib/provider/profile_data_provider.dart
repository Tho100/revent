import 'dart:typed_data';

import 'package:flutter/material.dart';

class ProfileDataProvider extends ChangeNotifier {

  String _bio = '';

  Uint8List _profilePicture = Uint8List(0);

  int _followers = 0;
  int _followings = 0;
  int _posts = 0;

  String get bio => _bio;

  Uint8List get profilePicture => _profilePicture;

  int get followers => _followers;
  int get followings => _followings;
  int get posts => _posts;

  void setBio(String bio) {
    _bio = bio;
    notifyListeners();
  }

  void setProfilePicture(Uint8List profilePicture) {
    _profilePicture = profilePicture;
    notifyListeners();
  }

  void setFollowers(int followers) {
    _followers = followers;
    notifyListeners();
  }

  void setFollowings(int followings) {
    _followings = followings;
    notifyListeners();
  }

  void setPosts(int posts) {
    _posts = posts;
    notifyListeners();
  }

}