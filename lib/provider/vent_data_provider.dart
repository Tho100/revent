import 'package:flutter/material.dart';

class VentDataProvider extends ChangeNotifier {
  
  List<String> _ventTitles = <String>[];

  List<String> get ventTitles => _ventTitles;

  void setVentTitles(List<String> titles) {
    _ventTitles = titles;
    notifyListeners();
  }

}