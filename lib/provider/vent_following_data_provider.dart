import 'dart:typed_data';

import 'package:flutter/material.dart';

class VentFollowing {

  String title;
  String bodyText;
  String creator;
  String postTimestamp;

  Uint8List profilePic;

  int totalLikes;
  int totalComments;

  bool isPostLiked;

  VentFollowing({
    required this.title,
    required this.bodyText,
    required this.creator,
    required this.postTimestamp,
    required this.profilePic,
    this.totalLikes = 0,
    this.totalComments = 0,
    this.isPostLiked = false
  });

}

class VentFollowingDataProvider extends ChangeNotifier {

  List<VentFollowing> _vents = [];

  List<VentFollowing> get vents => _vents;

  void setVents(List<VentFollowing> vents) {
    _vents = vents;
    notifyListeners();
  }

  void addVent(VentFollowing vent) {
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

}