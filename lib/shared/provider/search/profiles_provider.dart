import 'dart:typed_data';

import 'package:flutter/material.dart';

class SearchProfilesData {

  List<String> usernames = [];
  List<Uint8List> profilePictures = [];

  SearchProfilesData({
    required this.usernames,
    required this.profilePictures
  });

}

class SearchProfilesProvider extends ChangeNotifier {

  SearchProfilesData _profiles = SearchProfilesData(usernames: [], profilePictures: []);

  SearchProfilesData get profiles => _profiles; 

  void setProfiles(SearchProfilesData profiles) {
    _profiles = profiles;
    notifyListeners();
  }

  void clearAccounts() {
    _profiles = SearchProfilesData(usernames: [], profilePictures: []);
  }

}