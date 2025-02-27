import 'package:flutter/material.dart';

class UserData {

  String username;
  String email;
  String plan;
  Map<String, String> socialHandles;
  String? joinedDate;

  UserData({
    required this.username,
    required this.email,
    required this.plan,
    required this.socialHandles,
    this.joinedDate
  });

}

class UserProvider extends ChangeNotifier {
  
  UserData _user = UserData(username: '', email: '', plan: '', joinedDate: '', socialHandles: {});

  UserData get user => _user;

  void setUser(UserData user) {
    _user = user;
    notifyListeners();
  }

  void setJoinedDate(String joinedDate) {
    _user.joinedDate = joinedDate;
    notifyListeners();
  }

  void clearUserData() {
    _user = UserData(username: '', email: '', plan: '', joinedDate: '', socialHandles: {});
  }

}