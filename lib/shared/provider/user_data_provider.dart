import 'package:flutter/material.dart';

class User {

  String username;
  String email;
  String plan;
  String? joinedDate;

  User({
    required this.username,
    required this.email,
    required this.plan,
    this.joinedDate,
  });

}

class UserDataProvider extends ChangeNotifier {
  
  User _user = User(username: '', email: '', plan: '', joinedDate: '');

  User get user => _user;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  void setJoinedDate(String joinedDate) {
    _user.joinedDate = joinedDate;
    notifyListeners();
  }

  void clearUserData() {
    _user = User(username: '', email: '', plan: '', joinedDate: '');
  }

}