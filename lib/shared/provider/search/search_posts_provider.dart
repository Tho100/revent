import 'dart:typed_data';

import 'package:flutter/material.dart';

class SearchVentsData {

  int postId;

  String title;
  String tags;
  String postTimestamp;
  String creator;
  
  Uint8List profilePic;

  int totalLikes;
  int totalComments;

  bool isPostLiked;
  bool isPostSaved;
  bool isNsfw;

  SearchVentsData({
    required this.postId,
    required this.title,
    required this.tags,
    required this.postTimestamp,
    required this.creator,
    required this.profilePic,
    this.totalLikes = 0,
    this.totalComments = 0,
    this.isPostLiked = false,
    this.isPostSaved = false,
    this.isNsfw = false,
  });

}

class SearchPostsProvider extends ChangeNotifier {

  List<SearchVentsData> _vents = [];
  List<SearchVentsData> _filteredVents = [];

  List<SearchVentsData> get vents => _vents;
  List<SearchVentsData> get filteredVents => _filteredVents;

  void setVents(List<SearchVentsData> vents) {
    _vents = vents;
    _filteredVents = vents;
    notifyListeners();
  }

  void setFilteredVents(List<SearchVentsData> vents) {
    _filteredVents = vents;
    notifyListeners(); 
  }

  void deleteVent(int index) {
    if (index >= 0 && index < _vents.length) {
      _vents.removeAt(index);
      notifyListeners();
    }
  }

  void likeVent(int index, bool liked) {

    _vents[index].isPostLiked = liked;

    _vents[index].isPostLiked 
      ? _vents[index].totalLikes += 1
      : _vents[index].totalLikes -= 1;

    notifyListeners();
    
  }

  void saveVent(int index, bool saved) {
    _vents[index].isPostSaved = saved;
    notifyListeners();
  }

  void clearVents() {
    _vents.clear();
    _filteredVents.clear();
  }

}