import 'package:flutter/cupertino.dart';

class ActiveVentProvider extends ChangeNotifier {

  String _body = '';
  String _lastEdit = '';

  String get body => _body;
  String get lastEdit => _lastEdit;

  void setBody(String body) {
    _body = body;
    notifyListeners();
  }
  
  void setLastEdit(String lastEdit) {
    _lastEdit = lastEdit;
    notifyListeners();
  }

  void clearData() {
    _body = ''; 
    _lastEdit = '';
  }

}