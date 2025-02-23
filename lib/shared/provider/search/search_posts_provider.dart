import 'dart:typed_data';

import 'package:flutter/material.dart';

class SearchVents {

  String title;
  String creator;
  String postTimestamp;

  Uint8List profilePic;

  int totalLikes;
  int totalComments;

  bool isPostLiked;
  bool isPostSaved;

  SearchVents({
    required this.title,
    required this.creator,
    required this.postTimestamp,
    required this.profilePic,
    this.totalLikes = 0,
    this.totalComments = 0,
    this.isPostLiked = false,
    this.isPostSaved = false
  });

}

class SearchPostsProvider extends ChangeNotifier {

  List<SearchVents> _vents = [];
  List<SearchVents> _filteredVents = [];

  List<SearchVents> get vents => _vents;
  List<SearchVents> get filteredVents => _filteredVents;

  void setVents(List<SearchVents> vents) {
    _vents = vents;
    _filteredVents = vents;
    notifyListeners();
  }

  void setFilteredVents(List<SearchVents> vents) {
    _filteredVents = vents;
    notifyListeners(); 
  }

  // TODO: Remove this its unecessary
  void deleteVentsData() {
    _vents.clear();
    notifyListeners(); 
  }
  
  void likeVent(int index, bool isUserLikedPost) {

    _vents[index].isPostLiked = isUserLikedPost 
      ? false
      : true;

    _vents[index].isPostLiked 
      ? _vents[index].totalLikes += 1
      : _vents[index].totalLikes -= 1;

    notifyListeners();
    _updateFilteredVents();
    
  }

  void saveVent(int index, bool isUserSavedPost) {

    _vents[index].isPostSaved = isUserSavedPost 
      ? false
      : true;

    notifyListeners();
    _updateFilteredVents();

  }

  void clearVents() {
    _vents.clear();
    _filteredVents.clear();
  }

  void _updateFilteredVents() {
    _filteredVents = _vents;
    notifyListeners();
  }

}