import 'dart:typed_data';

import 'package:flutter/material.dart';

class SavedVentData {

  String title;
  String bodyText;
  String tags;
  String postTimestamp;
  String creator;

  Uint8List profilePic;

  int totalLikes;
  int totalComments;

  bool isPostLiked;
  bool isPostSaved;

  SavedVentData({
    required this.title,
    required this.bodyText,
    required this.tags,
    required this.postTimestamp,
    required this.creator,
    required this.profilePic,
    this.totalLikes = 0,
    this.totalComments = 0,
    this.isPostLiked = false,
    this.isPostSaved = false
  });

}

class SavedVentProvider extends ChangeNotifier {

  List<SavedVentData> _vents = [];

  List<SavedVentData> get vents => _vents;

  void setVents(List<SavedVentData> vents) {
    _vents = vents;
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
    
  }

  void saveVent(int index, bool isUserSavedPost) {

    _vents[index].isPostSaved = isUserSavedPost 
      ? false
      : true;

    notifyListeners();
    
  }

  void clearVents() {
    _vents.clear();
  }

}