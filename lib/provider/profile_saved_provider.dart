import 'dart:typed_data';

import 'package:flutter/material.dart';

class ProfileSavedData {

  List<String> creator = [];
  List<Uint8List> pfpData = [];

  List<String> titles = [];

  List<int> totalLikes = [];
  List<int> totalComments = [];

  List<String> postTimestamp = [];

  void clear() {
    creator.clear();
    pfpData.clear();
    titles.clear();
    totalLikes.clear();
    totalComments.clear();
    postTimestamp.clear();
  } 

}

class ProfileSavedProvider extends ChangeNotifier {

  final Map<String, ProfileSavedData> _profileData = {
    'my_profile': ProfileSavedData(),
    'user_profile': ProfileSavedData(),
  };

  ProfileSavedData get myProfile => _profileData['my_profile']!;
  ProfileSavedData get userProfile => _profileData['user_profile']!;

  void setCreator(String profileKey, List<String> creator) {
    _profileData[profileKey]?.creator = creator;
    notifyListeners();
  }

  void setProfilePicture(String profileKey, List<Uint8List> pfpData) {
    _profileData[profileKey]?.pfpData = pfpData;
    notifyListeners();
  }

  void setTitles(String profileKey, List<String> titles) {
    _profileData[profileKey]?.titles = titles;
    notifyListeners();
  }

  void setTotalLikes(String profileKey, List<int> totalLikes) {
    _profileData[profileKey]?.totalLikes = totalLikes;
    notifyListeners();
  }

  void setTotalComments(String profileKey, List<int> totalComments) {
    _profileData[profileKey]?.totalComments = totalComments;
    notifyListeners();
  }

  void setPostTimestamp(String profileKey, List<String> postTimestamp) {
    _profileData[profileKey]?.postTimestamp = postTimestamp;
    notifyListeners();
  }

  void clearPostsData() {
    for (var profile in _profileData.values) {
      profile.clear();
    }

    notifyListeners();
  }
}