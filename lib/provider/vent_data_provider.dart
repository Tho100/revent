import 'dart:typed_data';

import 'package:flutter/material.dart';

class Vent {

  String title;
  String bodyText;
  String creator;
  String postTimestamp;

  Uint8List profilePic;

  int totalLikes;
  int totalComments;

  Vent({
    required this.title,
    required this.bodyText,
    required this.creator,
    required this.postTimestamp,
    required this.profilePic,
    this.totalLikes = 0,
    this.totalComments = 0,
  });

}

class VentDataProvider extends ChangeNotifier {

  List<Vent> _vents = [];

  List<Vent> get vents => _vents;

  void setVents(List<Vent> vents) {
    _vents = vents;
    notifyListeners();
  }

  void addVent(Vent vent) {
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

}