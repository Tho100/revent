import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:revent/helper/app_route.dart';
import 'package:revent/provider/navigation_provider.dart';

class ProfilePostsData {

  List<String> titles = [];

  List<int> totalLikes = [];
  List<int> totalComments = [];

  List<String> postTimestamp = [];

  List<bool> isPostLiked = [];
  List<bool> isPostSaved = [];

  void clear() {
    titles.clear();
    totalLikes.clear();
    totalComments.clear();
    postTimestamp.clear();
    isPostLiked.clear();
    isPostSaved.clear();
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

  void setIsPostLiked(String profileKey, List<bool> isPostLiked) {
    _profileData[profileKey]?.isPostLiked = isPostLiked;
    notifyListeners(); 
  }

  void setIsPostSaved(String profileKey, List<bool> isPostSaved) {
    _profileData[profileKey]?.isPostSaved = isPostSaved;
    notifyListeners(); 
  }

  void clearPostsData() {
    for (var profile in _profileData.values) {
      profile.clear();
    }

    notifyListeners();
  }

  void deleteVent(int index) {

    final profile = _profileData['my_profile'];

    if (profile != null) {

      if (index >= 0 && index < profile.titles.length) {
        profile.titles.removeAt(index);
        profile.totalLikes.removeAt(index);
        profile.totalComments.removeAt(index);
        profile.postTimestamp.removeAt(index);
        notifyListeners();
      }
      
    }

  }

  void likeVent(int index, bool isUserLikedPost) {

    final navigation = GetIt.instance<NavigationProvider>();

    final profileKey = navigation.currentRoute == AppRoute.myProfile
      ? 'my_profile'
      : 'user_profile';

    final profile = _profileData[profileKey];

    if(profile != null) {

      profile.isPostLiked[index] = isUserLikedPost 
        ? false
        : true;

      profile.isPostLiked[index] 
        ? profile.totalLikes[index] += 1
        : profile.totalLikes[index] -= 1;

      notifyListeners();

    }
    
  }

  void saveVent(int index, bool isUserSavedPost) {

    final navigation = GetIt.instance<NavigationProvider>();

    final profileKey = navigation.currentRoute == '/profile/my_profile/' 
      ? 'my_profile'
      : 'user_profile';

    final profile = _profileData[profileKey];

    if(profile != null) {

      profile.isPostSaved[index] = isUserSavedPost 
        ? false
        : true;

      notifyListeners();

    }
    
  }

}