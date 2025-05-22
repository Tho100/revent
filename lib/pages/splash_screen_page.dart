import 'dart:async';

import 'package:flutter/material.dart';
import 'package:revent/shared/themes/theme_updater.dart';
import 'package:revent/helper/providers_service.dart';
import 'package:revent/main.dart';
import 'package:revent/model/setup/profile_data_setup.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/model/local_storage_model.dart';
import 'package:revent/shared/provider/user_provider.dart';
import 'package:revent/shared/themes/app_theme.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/model/setup/vent_data_setup.dart';

class SplashScreen extends StatefulWidget {

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();

}

class _SplashScreenState extends State<SplashScreen> with UserProfileProviderService {

  final localStorage = LocalStorageModel();

  Timer? splashScreenTimer;

  Widget _buildSplashScreen() {
    return Container(
      color: ThemeColor.backgroundPrimary,
      child: Align(
        alignment: Alignment.center,
        child: Center(
          child: Image.asset(
            'assets/images/albert_icon.png',
            width: 280,
            height: 280,
            fit: BoxFit.contain,
          )
        )
      )
    );  
  }

  Future<void> _loadStartupData() async {

    final currentTab = await localStorage.readCurrentHomeTab();

    await ProfileDataSetup().setup(username: userProvider.user.username).then(
      (_) async {

        if (currentTab == 'For you') {
          await VentDataSetup().setupForYou();
          
        } else if (currentTab == 'Trending') {
          await VentDataSetup().setupTrending();

        } else if (currentTab == 'Following') {
          await VentDataSetup().setupFollowing();

        }

      }
    );

    await localStorage.readThemeInformation().then(
      (theme) => ThemeUpdater(theme: theme).updateTheme()
    );

    globalThemeNotifier.value = GlobalAppTheme().buildAppTheme();

  }

  void _startTimer() async {

    final localUsername = (await localStorage.readLocalAccountInformation())['username']!;

    if(localUsername.isNotEmpty) {
      splashScreenTimer = Timer(const Duration(milliseconds: 0), 
        () => _navigateToNextScreen()
      );

    } else {
      splashScreenTimer = Timer(const Duration(milliseconds: 2000), 
        () => _navigateToNextScreen()
      );
      
    }
    
  }

  void _navigateToNextScreen() async {

    try {

      final readLocalData = await localStorage.readLocalAccountInformation();

      final username = readLocalData['username']!;
      final email = readLocalData['email']!;

      if(username.isEmpty) {
        NavigatePage.mainScreenPage();
        return;
      }

      final socialHandles = await localStorage.readLocalSocialHandles();

      final userSetup = UserData(
        username: username, 
        email: email, 
        socialHandles: socialHandles
      );

      userProvider.setUser(userSetup);

      await _loadStartupData().then(
        (_) => NavigatePage.homePage()
      );

    } catch (_) {
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