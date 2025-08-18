import 'dart:typed_data';

import 'package:flutter/material.dart';

class ProfileData {

  String bio;
  String pronouns;
  String country;

  Uint8List profilePicture;

  int followers;
  int following;

  ProfileData({
    required this.bio,
    required this.pronouns,
    required this.country,
    required this.profilePicture,
    required this.followers,
    required this.following,
  });

}

class ProfileProvider extends ChangeNotifier {

  ProfileData _profile = ProfileData(
    bio: '', 
    pronouns: '', 
    country: '',
    profilePicture: Uint8List(0), 
    followers: 0, 
    following: 0
  ); 

  ProfileData get profile => _profile;

  void setProfile(ProfileData profile) {
    _profile = profile;
    notifyListeners();
  }

  void clearProfileData() {
    _profile.bio = '';
    _profile.pronouns = ''; 
    _profile.country = '';
    _profile.profilePicture = Uint8List(0); 
    _profile.followers = 0;
    _profile.following = 0;
  }

}