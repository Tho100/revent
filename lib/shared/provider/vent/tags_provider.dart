import 'package:flutter/material.dart';

class TagsProvider extends ChangeNotifier {
  
  final List<String> _selectedTags = [];

  List<String> get selectedTags => _selectedTags;

  void addItem(String item) {
    _selectedTags.add(item);
    notifyListeners();
  }

  void removeItem(int index) {
    _selectedTags.removeAt(index);
    notifyListeners();
  }

}