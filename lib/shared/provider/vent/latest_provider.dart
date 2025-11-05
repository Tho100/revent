import 'dart:typed_data';

import 'package:flutter/material.dart';

class VentLatestData {

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

  VentLatestData({
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
    this.isNsfw = false
  });

}

class VentLatestProvider extends ChangeNotifier {

  List<VentLatestData> _vents = [];

  List<VentLatestData> get vents => _vents;

  void setVents(List<VentLatestData> vents) {
    _vents = vents;
    notifyListeners();
  }

  void addVent(VentLatestData vent) {
    _vents.insert(0, vent);
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