import 'package:flutter/material.dart';

class ProfilePostsData {

  List<String> titles = [];

  List<int> totalLikes = [];
  List<int> totalComments = [];

  List<String> postTimestamp = [];

  void clear() {
    titles.clear();
    totalLikes.clear();
    totalComments.clear();
    postTimestamp.clear();
  } 

}

class ProfilePostsProvider extends ChangeNotifier {

  final Map<String, ProfilePostsData> _profileData = {
    'my_profile': ProfilePostsData(),
    'user_profile': ProfilePostsData(),
  };

  ProfilePostsData get myProfile => _profileData['my_profile']!;
  ProfilePostsData get userProfile => _profileData['user_profile']!;

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