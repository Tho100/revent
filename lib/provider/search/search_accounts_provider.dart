import 'dart:typed_data';

import 'package:flutter/material.dart';

class SearchAccountsData {

  List<String> usernames = [];
  List<Uint8List> profilePictures = [];

  SearchAccountsData({
    required this.usernames,
    required this.profilePictures
  });

}

class SearchAccountsProvider extends ChangeNotifier {

  SearchAccountsData _accounts = SearchAccountsData(usernames: [], profilePictures: []);

  SearchAccountsData get accounts => _accounts; 

  void setAccounts(SearchAccountsData accounts) {
    _accounts = accounts;
    notifyListeners();
  }

  void clearAccounts() {
    _accounts = SearchAccountsData(usernames: [], profilePictures: []);
  }

}