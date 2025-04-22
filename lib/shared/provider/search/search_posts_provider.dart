import 'dart:typed_data';

import 'package:flutter/material.dart';

class SearchVents {

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

  SearchVents({
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

  void clearVents() {
    _vents.clear();
    _filteredVents.clear();
  }

}