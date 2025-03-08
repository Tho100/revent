import 'package:flutter/material.dart';

class TagsProvider extends ChangeNotifier {
  
  final List<String> _tags = [];

  List<String> get selectedTags => _tags;

  void addItem(String item) {
    _tags.add(item);
    notifyListeners();
  }

  void removeItem(int index) {
    _tags.removeAt(index);
    notifyListeners();
  }

}