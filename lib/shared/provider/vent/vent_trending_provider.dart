import 'dart:typed_data';

import 'package:flutter/material.dart';

class VentTrendingData {

  String title;
  String bodyText;
  String creator;
  String postTimestamp;

  Uint8List profilePic;

  int totalLikes;
  int totalComments;

  bool isPostLiked;
  bool isPostSaved;

  VentTrendingData({
    required this.title,
    required this.bodyText,
    required this.creator,
    required this.postTimestamp,
    required this.profilePic,
    this.totalLikes = 0,
    this.totalComments = 0,
    this.isPostLiked = false,
    this.isPostSaved = false
  });

}

class VentTrendingProvider extends ChangeNotifier {

  List<VentTrendingData> _vents = [];

  List<VentTrendingData> get vents => _vents;

  void setVents(List<VentTrendingData> vents) {
    _vents = vents;
    notifyListeners();
  }

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
    
  }

  void saveVent(int index, bool isUserSavedPost) {

    _vents[index].isPostSaved = isUserSavedPost 
      ? false
      : true;

    notifyListeners();
    
  }

}