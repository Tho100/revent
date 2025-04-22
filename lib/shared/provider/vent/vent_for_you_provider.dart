import 'dart:typed_data';

import 'package:flutter/material.dart';

class VentForYouData {

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
  bool isNsfw;

  VentForYouData({
    required this.title,
    required this.bodyText,
    required this.tags,
    required this.postTimestamp,
    required this.creator,
    required this.profilePic,
    this.totalLikes = 0,
    this.totalComments = 0,
    this.isPostLiked = false,
    this.isPostSaved = false,
    this.isNsfw = false
  });

}

class VentForYouProvider extends ChangeNotifier {

  List<VentForYouData> _vents = [];

  List<VentForYouData> get vents => _vents;

  void setVents(List<VentForYouData> vents) {
    _vents = vents;
    notifyListeners();
  }

  void addVent(VentForYouData vent) {
    _vents.add(vent);
    notifyListeners();
  }

  void deleteVentsData() {
    _vents.clear();
    notifyListeners();
  }

  void deleteVent(int index) {
    if (index >= 0 && index < _vents.length) {
      _vents.removeAt(index);
      notifyListeners();
    }
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

}