import 'package:flutter/material.dart';

class UserData {

  String username;
  String email;

  Map<String, String>? socialHandles;

  String? joinedDate;

  UserData({
    required this.username,
    required this.email,
    this.socialHandles,
    this.joinedDate
  });

}

class UserProvider extends ChangeNotifier {
  
  UserData _user = UserData(username: '', email: '', joinedDate: '', socialHandles: {});

  UserData get user => _user;

  void setUser(UserData user) {
    _user = user;
    notifyListeners();
  }

  void setJoinedDate(String joinedDate) {
    _user.joinedDate = joinedDate;
    notifyListeners();
  }

  void setSocialHandles(Map<String, String> socialHandles) {
    _user.socialHandles = socialHandles;
    notifyListeners();
  }

  void clearUserData() {
    _user = UserData(username: '', email: '', joinedDate: '', socialHandles: {});
  }

}