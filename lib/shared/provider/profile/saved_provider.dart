import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:revent/app/app_route.dart';
import 'package:revent/global/type/profile_type.dart';
import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/main.dart';

class ProfileSavedData {

  List<int> postIds = [];

  List<String> titles = [];
  List<String> bodyText = [];
  List<String> tags = [];
  List<String> postTimestamp = [];

  List<int> totalLikes = [];
  List<int> totalComments = [];

  List<String> creator = [];
  List<Uint8List> pfpData = [];

  List<bool> isNsfw = [];
  List<bool> isPostLiked = [];
  List<bool> isPostSaved = [];

  void clear() {
    postIds.clear();
    titles.clear();
    bodyText.clear();
    tags.clear();
    postTimestamp.clear();
    creator.clear();
    pfpData.clear();
    totalLikes.clear();
    totalComments.clear();
    isNsfw.clear();
    isPostLiked.clear();
    isPostSaved.clear();
  } 

}

class ProfileSavedProvider extends ChangeNotifier {

  final Map<ProfileType, ProfileSavedData> _profileData = {
    ProfileType.myProfile: ProfileSavedData(),
    ProfileType.userProfile: ProfileSavedData(),
  };

  ProfileSavedData get myProfile => _profileData[ProfileType.myProfile]!;
  ProfileSavedData get userProfile => _profileData[ProfileType.userProfile]!;

  void setPostIds(ProfileType profileKey, List<int> postIds) {
    _profileData[profileKey]?.postIds = postIds;
    notifyListeners();
  }

  void setCreator(ProfileType profileKey, List<String> creator) {
    _profileData[profileKey]?.creator = creator;
    notifyListeners();
  }

  void setProfilePicture(ProfileType profileKey, List<Uint8List> pfpData) {
    _profileData[profileKey]?.pfpData = pfpData;
    notifyListeners();
  }

  void setTitles(ProfileType profileKey, List<String> titles) {
    _profileData[profileKey]?.titles = titles;
    notifyListeners();
  }

  void setBodyText(ProfileType profileKey, List<String> bodyText) {
    _profileData[profileKey]?.bodyText = bodyText;
    notifyListeners();
  }

  void setTotalLikes(ProfileType profileKey, List<int> totalLikes) {
    _profileData[profileKey]?.totalLikes = totalLikes;
    notifyListeners();
  }

  void setTotalComments(ProfileType profileKey, List<int> totalComments) {
    _profileData[profileKey]?.totalComments = totalComments;
    notifyListeners();
  }

  void setPostTimestamp(ProfileType profileKey, List<String> postTimestamp) {
    _profileData[profileKey]?.postTimestamp = postTimestamp;
    notifyListeners();
  }

  void setTags(ProfileType profileKey, List<String> tags) {
    _profileData[profileKey]?.tags = tags;
    notifyListeners();
  }

  void setIsNsfw(ProfileType profileKey, List<bool> isNsfw) {
    _profileData[profileKey]?.isNsfw = isNsfw;
    notifyListeners(); 
  }

  void setIsPostLiked(ProfileType profileKey, List<bool> isPostLiked) {
    _profileData[profileKey]?.isPostLiked = isPostLiked;
    notifyListeners(); 
  }

  void setIsPostSaved(ProfileType profileKey, List<bool> isPostSaved) {
    _profileData[profileKey]?.isPostSaved = isPostSaved;
    notifyListeners(); 
  }

  void clearPostsData() {
    
    for (final profile in _profileData.values) {
      profile.clear();
    }

    notifyListeners();

  }

  void deleteVent(int index) {

    final profile = _profileData[ProfileType.myProfile];

    if (profile != null) {

      if (index >= 0 && index < profile.titles.length) {
        profile.titles.removeAt(index);
        profile.bodyText.removeAt(index);
        profile.tags.removeAt(index);
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

  void likeVent(int index, bool liked) {

    final profileKey = _getCurrentProfileKey();

    final profile = _profileData[profileKey];

    if (profile != null) {

      profile.isPostLiked[index] = liked;

      profile.isPostLiked[index] 
        ? profile.totalLikes[index] += 1
        : profile.totalLikes[index] -= 1;

      notifyListeners();

    }
    
  }

  void saveVent(int index, bool saved) {

    final profileKey = _getCurrentProfileKey();

    final profile = _profileData[profileKey];

    if (profile != null) {

      profile.isPostSaved[index] = saved;

      notifyListeners();

    }
    
  }

  ProfileType _getCurrentProfileKey() {
    return getIt.navigationProvider.currentRoute == AppRoute.myProfile
      ? ProfileType.myProfile
      : ProfileType.userProfile;
  }

}