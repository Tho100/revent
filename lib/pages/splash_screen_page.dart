import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/model/setup/profile_data_setup.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/main.dart';
import 'package:revent/model/local_storage_model.dart';
import 'package:revent/shared/provider/user_provider.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/model/setup/vent_data_setup.dart';

class SplashScreen extends StatefulWidget {

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();

}

class _SplashScreenState extends State<SplashScreen> {

  final userData = getIt.userProvider;

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

    await ProfileDataSetup().setup(username: userData.user.username).then(
      (_) async => await VentDataSetup().setupForYou()
    );

  }

  void _startTimer() async {

    final localUsername = (await localModel.readLocalAccountInformation())['username']!;

    if(localUsername.isNotEmpty) {
      splashScreenTimer = Timer(const Duration(milliseconds: 0), 
        () => _navigateToNextScreen()
      );

    } else {
      splashScreenTimer = Timer(const Duration(milliseconds: 1750), 
        () => _navigateToNextScreen()
      );
      
    }
    
  }

  void _navigateToNextScreen() async {

    try {

      final readLocalData = await localModel.readLocalAccountInformation();

      final username = readLocalData['username']!;
      final email = readLocalData['email']!;
      final accountPlan = readLocalData['plan']!;

      if(username.isEmpty) {
        NavigatePage.mainScreenPage();
        return;
      }

      final userSetup = UserData(
        username: username, 
        email: email, 
        plan: accountPlan, 
      );

      userData.setUser(userSetup);

      await _loadStartupData().then(
        (_) => NavigatePage.homePage()
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