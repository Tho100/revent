import 'dart:typed_data';

import 'package:flutter/material.dart';

class VentDataProvider extends ChangeNotifier {
  
  List<String> _ventTitles = <String>[];
  List<String> _ventBodyText = <String>[];
  List<String> _ventCreator = <String>[];
  List<String> _ventPostTimestamp = <String>[];

  List<int> _ventTotalLikes = <int>[];
  List<int> _ventTotalComments = <int>[];

  List<Uint8List> _ventProfilePic = <Uint8List>[]; //TODO: Remove unused typed-specific

  List<String> get ventTitles => _ventTitles;
  List<String> get ventBodyText => _ventBodyText;
  List<String> get ventCreator => _ventCreator;
  List<String> get ventPostTimestamp => _ventPostTimestamp;

  List<int> get ventTotalLikes => _ventTotalLikes;
  List<int> get ventTotalComments => _ventTotalComments;

  List<Uint8List> get ventProfilePic => _ventProfilePic;

  void setVentTitles(List<String> titles) {
    _ventTitles = titles;
    notifyListeners();
  }

  void setVentBodyText(List<String> bodyText) {
    _ventBodyText = bodyText;
    notifyListeners();
  }

  void setVentCreator(List<String> creator) {
    _ventCreator = creator;
    notifyListeners();
  }

  void setVentPostTimestamp(List<String> postTimestamp) {
    _ventPostTimestamp = postTimestamp;
    notifyListeners();
  }

  void setVentTotalLikes(List<int> creator) {
    _ventTotalLikes = creator;
    notifyListeners();
  }

  void setVentTotalComments(List<int> postTimestamp) {
    _ventTotalComments = postTimestamp;
    notifyListeners();
  }

  void setVentProfilePic(List<Uint8List> pfpData) {
    _ventProfilePic = pfpData;
    notifyListeners();
  }

  void addVentData(String title, String bodyText, String creator, String postTimestamp, Uint8List pfpData) {
    _ventTitles.add(title);
    _ventBodyText.add(bodyText);
    _ventCreator.add(creator);
    _ventPostTimestamp.add(postTimestamp);
    _ventProfilePic.add(pfpData);
    _ventTotalLikes.add(0);
    _ventTotalComments.add(0);
    notifyListeners();
  }

  void deleteVentData() {
    _ventTitles.clear();
    _ventBodyText.clear();
    _ventCreator.clear();
    _ventPostTimestamp.clear();
    _ventTotalLikes.clear();
    _ventTotalComments.clear();
    notifyListeners();
  }

}