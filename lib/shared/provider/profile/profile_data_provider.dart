import 'dart:typed_data';

import 'package:flutter/material.dart';

class ProfileMainData {

  String bio;
  String pronouns;

  Uint8List profilePicture;

  int followers;
  int following;

  ProfileMainData({
    required this.bio,
    required this.pronouns,
    required this.profilePicture,
    required this.followers,
    required this.following,
  });

}

class ProfileDataProvider extends ChangeNotifier {

  ProfileMainData _profile = ProfileMainData(
    bio: '', 
    pronouns: '', 
    profilePicture: Uint8List(0), 
    followers: 0, 
    following: 0
  ); 

  ProfileMainData get profile => _profile;

  void setProfile(ProfileMainData profile) {
    _profile = profile;
    notifyListeners();
  }

  void clearProfileData() {
    _profile.bio = '';
    _profile.pronouns = ''; 
    _profile.profilePicture = Uint8List(0); 
    _profile.followers = 0;
    _profile.following = 0;
  }

}