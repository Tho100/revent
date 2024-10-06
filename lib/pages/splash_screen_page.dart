import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/model/local_storage_model.dart';
import 'package:revent/provider/user_data_provider.dart';
import 'package:revent/security/encryption_model.dart';
import 'package:revent/themes/theme_color.dart';

class SplashScreen extends StatefulWidget {

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => SplashScreenState();

}

class SplashScreenState extends State<SplashScreen> {

  final localModel = LocalStorageModel();
  final encryption = EncryptionClass();

  final userData = GetIt.instance<UserDataProvider>();

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

  void _startTimer() async {
    
    if ((await localModel.readLocalAccountInformation())[0] != '') {
      splashScreenTimer = Timer(const Duration(milliseconds: 0), () {
        _navigateToNextScreen();
      });

    } else {
      splashScreenTimer = Timer(const Duration(milliseconds: 2000), () {
        _navigateToNextScreen();
      });
      
    }
    
  }

  void _navigateToNextScreen() async {

    try {

      final readLocalData = await localModel.readLocalAccountInformation();

      final getLocalUsername = readLocalData[0];
      final getLocalEmail = readLocalData[1];
      final getLocalAccountType = readLocalData[2];

      if(getLocalUsername == '') {

        if(mounted) {
          NavigatePage.mainScreenPage(context);
        }

      } else {

        userData.setAccountType(getLocalAccountType);
        userData.setUsername(getLocalUsername);
        userData.setEmail(getLocalEmail);

        //final conn = await SqlConnection.initializeConnection();
        //await _getStartupDataFiles(conn, getLocalUsername, getLocalEmail, getLocalAccountType);
        
        if(mounted) {
          NavigatePage.homePage(context);
        }
        
      }

    } catch (err) {
      NavigatePage.mainScreenPage(context);
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