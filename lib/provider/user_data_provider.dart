import 'package:flutter/material.dart';

class UserDataProvider extends ChangeNotifier {

  String _username = '';
  String _email = '';
  String _plan = '';

  String get username => _username;
  String get email => _email;
  String get plan => _plan;
  
  void setUsername(String username) {
    _username = username;
    notifyListeners();
  }

  void setEmail(String email) {
    _email = email;
    notifyListeners();
  }

  void setAccountPlan(String plan) {
    _plan = plan;
    notifyListeners();
  }
  
}