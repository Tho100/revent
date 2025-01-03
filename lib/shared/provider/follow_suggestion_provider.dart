import 'dart:typed_data';

import 'package:flutter/material.dart';

class FollowSuggestionData {

  String username;
  Uint8List profilePic;
  
  FollowSuggestionData({
    required this.username,
    required this.profilePic
  });

}

class FollowSuggestionProvider extends ChangeNotifier {

  List<FollowSuggestionData> _suggestions = [];

  List<FollowSuggestionData> get suggestions => _suggestions; 

  void setSuggestions(List<FollowSuggestionData> suggestions) {
    _suggestions = suggestions;
    notifyListeners();
  }

  void removeSuggestion(int index) {
    if (index >= 0 && index < _suggestions.length) {
      _suggestions.removeAt(index);
      notifyListeners();
    }
  }

}