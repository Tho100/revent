import 'dart:typed_data';

import 'package:flutter/material.dart';

class ProfileDataProvider extends ChangeNotifier {

  String _bio = '';
  String _pronouns = '';

  Uint8List _profilePicture = Uint8List(0);

  int _followers = 0;
  int _following = 0;
  int _posts = 0;

  String get bio => _bio;
  String get pronouns => _pronouns;

  Uint8List get profilePicture => _profilePicture;

  int get followers => _followers;
  int get following => _following;
  int get posts => _posts;

  void setBio(String bio) {
    _bio = bio;
    notifyListeners();
  }

  void setPronouns(String pronouns) {
    _pronouns = pronouns;
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

  void setFollowing(int following) {
    _following = following;
    notifyListeners();
  }

  void setPosts(int posts) {
    _posts = posts;
    notifyListeners();
  }

  void clearProfileData() {
    _posts = 0;
    _followers = 0;
    _following = 0;
    _bio = '';
    _profilePicture = Uint8List(0);
    notifyListeners();
  }

}