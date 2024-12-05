import 'package:flutter/cupertino.dart';

class ActiveVentProvider extends ChangeNotifier {

  String _body = '';

  String get body => _body;

  void setBody(String body) {
    _body = body;
    notifyListeners();
  }
  
  void clearData() {
    _body = ''; 
  }

}