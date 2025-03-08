import 'package:flutter/material.dart';

class TagsProvider extends ChangeNotifier {
  
  final List<String> _selectedTags = [];

  List<String> get selectedTags => _selectedTags;

  void addTags(List<String> tags) {
    selectedTags..clear()..addAll(tags);
    notifyListeners();
  }

}