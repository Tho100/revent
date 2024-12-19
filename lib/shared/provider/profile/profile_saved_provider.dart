import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:revent/app/app_route.dart';
import 'package:revent/shared/provider/navigation_provider.dart';

class ProfileSavedData {

  List<String> creator = [];
  List<Uint8List> pfpData = [];

  List<String> titles = [];
  List<String> bodyText = [];

  List<int> totalLikes = [];
  List<int> totalComments = [];

  List<String> postTimestamp = [];

  List<bool> isPostLiked = [];
  List<bool> isPostSaved = [];

  void clear() {
    creator.clear();
    pfpData.clear();
    titles.clear();
    totalLikes.clear();
    totalComments.clear();
    postTimestamp.clear();
    isPostLiked.clear();
    isPostSaved.clear();
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

  void setBodyText(String profileKey, List<String> bodyText) {
    _profileData[profileKey]?.bodyText = bodyText;
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
        profile.pfpData.removeAt(index);
        profile.creator.removeAt(index);
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

    final profileKey = navigation.currentRoute == AppRoute.myProfile
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