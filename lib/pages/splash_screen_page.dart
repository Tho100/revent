import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/data_query/user_profile/profile_data_setup.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/model/local_storage_model.dart';
import 'package:revent/provider/user_data_provider.dart';
import 'package:revent/themes/theme_color.dart';
import 'package:revent/vent_query/vent_data_setup.dart';

class SplashScreen extends StatefulWidget {

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => SplashScreenState();

}

class SplashScreenState extends State<SplashScreen> {

  final userData = GetIt.instance<UserDataProvider>();

  final localModel = LocalStorageModel();

  Timer? splashScreenTimer;

  Widget _buildSplashScreen() {
    return Container(
      color: ThemeColor.black,
      child: Align(
        alignment: Alignment.center,
        child: Center(
          child: Text(
            'Revent',
            style: GoogleFonts.inter(
              color: ThemeColor.white,
              fontWeight: FontWeight.w900,
              fontSize: 50
            )
          )
        )
      )
    );  
  }

  Future<void> _loadStartupData() async {
    
    await ProfileDataSetup().setup(username: userData.user.username);

    await VentDataSetup().setup();

  }

  void _startTimer() async {

    final localUsername = (await localModel.readLocalAccountInformation())['username']!;

    if(localUsername.isNotEmpty) {
    splashScreenTimer = Timer(const Duration(milliseconds: 0), () {
        _navigateToNextScreen();
      });

    } else {
      splashScreenTimer = Timer(const Duration(milliseconds: 1750), () {
        _navigateToNextScreen();
      });
      
    }
    
  }

  void _navigateToNextScreen() async {

    try {

      final readLocalData = await localModel.readLocalAccountInformation();

      final getLocalUsername = readLocalData['username']!;
      final getLocalEmail = readLocalData['email']!;
      final getLocalAccountType = readLocalData['plan']!;

      if(getLocalUsername.isEmpty) {
        NavigatePage.mainScreenPage();
        return;
      }

      final userSetup = User(
        username: getLocalUsername, 
        email: getLocalEmail, 
        plan: getLocalAccountType, 
      );

      userData.setUser(userSetup);

      await _loadStartupData()
        .then((value) => NavigatePage.homePage()
      );

    } catch (err) {
      NavigatePage.mainScreenPage();
    }

  }

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    splashScreenTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildSplashScreen()
    );
  }

}