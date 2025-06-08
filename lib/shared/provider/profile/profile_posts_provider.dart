import 'package:flutter/material.dart';
import 'package:revent/app/app_route.dart';
import 'package:revent/global/profile_type.dart';
import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/main.dart';

class ProfilePostsData {

  List<String> titles = [];
  List<String> bodyText = [];
  List<String> tags = [];
  List<String> postTimestamp = [];

  List<int> totalLikes = [];
  List<int> totalComments = [];

  List<bool> isNsfw = [];
  List<bool> isPinned = [];
  List<bool> isPostLiked = [];
  List<bool> isPostSaved = [];

  void clear() {
    titles.clear();
    bodyText.clear();
    tags.clear();
    totalLikes.clear();
    totalComments.clear();
    postTimestamp.clear();
    isNsfw.clear();
    isPinned.clear();
    isPostLiked.clear();
    isPostSaved.clear();
  } 

}

class ProfilePostsProvider extends ChangeNotifier {

  final Map<String, ProfilePostsData> _profileData = {
    ProfileType.myProfile.value: ProfilePostsData(),
    ProfileType.userProfile.value: ProfilePostsData(),
  };

  ProfilePostsData get myProfile => _profileData[ProfileType.myProfile.value]!;
  ProfilePostsData get userProfile => _profileData[ProfileType.userProfile.value]!;

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

  void setIsNsfw(String profileKey, List<bool> isNsfw) {
    _profileData[profileKey]?.isNsfw = isNsfw;
    notifyListeners();
  }

  void setIsPinned(String profileKey, List<bool> isPinned) {
    _profileData[profileKey]?.isPinned = isPinned;
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
        profile.isPostLiked.removeAt(index);
        profile.isPostSaved.removeAt(index);
        notifyListeners();
      }
      
    }

  }

  void likeVent(int index, bool isUserLikedPost) {

    final profileKey = _getCurrentProfileKey();

    final profile = _profileData[profileKey];

    if (profile != null) {

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

    final profileKey = _getCurrentProfileKey();

    final profile = _profileData[profileKey];

    if (profile != null) {

      profile.isPostSaved[index] = isUserSavedPost 
        ? false
        : true;

      notifyListeners();

    }
    
  }

  void reorderPosts() {

    final profileKey = _getCurrentProfileKey();
    
    final profile = _profileData[profileKey];

    if (profile != null) {

      List<int> pinnedIndices = [];
      List<int> nonPinnedIndices = [];

      for (int i = 0; i < profile.isPinned.length; i++) {
        if (profile.isPinned[i]) {
          pinnedIndices.add(i);
        } else {
          nonPinnedIndices.add(i);
        }
      }

      List<int> finalOrder = [...pinnedIndices, ...nonPinnedIndices];

      profile.titles = _reorderList(profile.titles, finalOrder);
      profile.bodyText = _reorderList(profile.bodyText, finalOrder);
      profile.tags = _reorderList(profile.tags, finalOrder);
      profile.totalLikes = _reorderList(profile.totalLikes, finalOrder);
      profile.totalComments = _reorderList(profile.totalComments, finalOrder);
      profile.postTimestamp = _reorderList(profile.postTimestamp, finalOrder);
      profile.isNsfw = _reorderList(profile.isNsfw, finalOrder);
      profile.isPinned = _reorderList(profile.isPinned, finalOrder);
      profile.isPostLiked = _reorderList(profile.isPostLiked, finalOrder);
      profile.isPostSaved = _reorderList(profile.isPostSaved, finalOrder);

      notifyListeners();
    }

  }

  List<T> _reorderList<T>(List<T> list, List<int> order) {
    return order.map((index) => list[index]).toList();
  }

  String _getCurrentProfileKey() {

    final navigation = getIt.navigationProvider;

    return navigation.currentRoute == AppRoute.myProfile.path
      ? ProfileType.myProfile.value
      : ProfileType.userProfile.value;

  }

}