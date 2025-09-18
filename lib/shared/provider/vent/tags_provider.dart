import 'package:flutter/material.dart';

class TagsProvider extends ChangeNotifier {
  
  List<String> _selectedTags = [];

  List<String> get selectedTags => _selectedTags;

  void addTags(List<String> tags) {
    _selectedTags = List.from(tags);
    notifyListeners();
  }

}