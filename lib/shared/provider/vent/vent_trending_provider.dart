import 'dart:typed_data';

import 'package:flutter/material.dart';

class VentTrendingData {

  int postId;

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

  VentTrendingData({
    required this.postId,
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
    this.isNsfw = false,
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

}