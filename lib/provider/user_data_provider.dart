import 'package:flutter/material.dart';

class UserDataProvider extends ChangeNotifier {

  String _username = '';
  String _email = '';
  String _accountType = '';

  String get username => _username;
  String get email => _email;
  String get accountType => _accountType;
  
  void setUsername(String username) {
    _username = username;
    notifyListeners();
  }

  void setEmail(String email) {
    _email = email;
    notifyListeners();
  }

  void setAccountType(String accountType) {
    _accountType = accountType;
    notifyListeners();
  }
  
}