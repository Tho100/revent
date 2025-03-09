import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:revent/app/app_route.dart';
import 'package:revent/global/profile_type.dart';
import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/main.dart';

class ProfileSavedData {

  List<String> creator = [];
  List<Uint8List> pfpData = [];

  List<String> titles = [];
  List<String> bodyText = [];

  List<int> totalLikes = [];
  List<int> totalComments = [];

  List<String> postTimestamp = [];
  List<String> tags = [];

  List<bool> isPostLiked = [];
  List<bool> isPostSaved = [];

  void clear() {
    titles.clear();
    bodyText.clear();
    creator.clear();
    pfpData.clear();
    totalLikes.clear();
    totalComments.clear();
    postTimestamp.clear();
    tags.clear();
    isPostLiked.clear();
    isPostSaved.clear();
  } 

}

class ProfileSavedProvider extends ChangeNotifier {

  final Map<String, ProfileSavedData> _profileData = {
    ProfileType.myProfile.value: ProfileSavedData(),
    ProfileType.userProfile.value: ProfileSavedData(),
  };

  ProfileSavedData get myProfile => _profileData[ProfileType.myProfile.value]!;
  ProfileSavedData get userProfile => _profileData[ProfileType.userProfile.value]!;

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

  void setTags(String profileKey, List<String> tags) {
    _profileData[profileKey]?.tags = tags;
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

    final profile = _profileData[ProfileType.myProfile.value];

    if (profile != null) {

      if (index >= 0 && index < profile.titles.length) {
        profile.titles.removeAt(index);
        profile.bodyText.removeAt(index);
        profile.totalLikes.removeAt(index);
        profile.totalComments.removeAt(index);
        profile.postTimestamp.removeAt(index);
        profile.pfpData.removeAt(index);
        profile.creator.removeAt(index);
        profile.isPostLiked.removeAt(index);
        profile.isPostSaved.removeAt(index);
        notifyListeners();
      }
      
    }

  }

  void likeVent(int index, bool isUserLikedPost) {

    final navigation = getIt.navigationProvider;

    final profileKey = navigation.currentRoute == AppRoute.myProfile.path
      ? ProfileType.myProfile.value
      : ProfileType.userProfile.value;

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

    final navigation = getIt.navigationProvider;

    final profileKey = navigation.currentRoute == AppRoute.myProfile.path
      ? ProfileType.myProfile.value
      : ProfileType.userProfile.value;

    final profile = _profileData[profileKey];

    if(profile != null) {

      profile.isPostSaved[index] = isUserSavedPost 
        ? false
        : true;

      notifyListeners();

    }
    
  }

}