import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:revent/global/tabs_type.dart';
import 'package:revent/service/activity_service.dart';
import 'package:revent/shared/themes/theme_updater.dart';
import 'package:revent/shared/provider_mixins.dart';
import 'package:revent/main.dart';
import 'package:revent/model/setup/profile_data_setup.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/model/local_storage_model.dart';
import 'package:revent/shared/provider/user_provider.dart';
import 'package:revent/shared/themes/app_theme.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/model/setup/vents_setup.dart';

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

  Future<void> _initializeQuickActions() async {

    const quickActions = QuickActions();
    
    quickActions.initialize((String actionType) {

      if (actionType == 'new_vent') {
        NavigatePage.createVentPage();
      } 
  
    });

    quickActions.setShortcutItems([
      const ShortcutItem(
        type: 'new_vent',
        localizedTitle: 'New Vent',
      )
    ]);

  }

  Future<void> _initializeHomeVents() async {

    final currentTabString = await localStorage.readCurrentHomeTab();

    final currentTab = HomeTabs.values.firstWhere(
      (tab) => tab.name == currentTabString
    );

    if (currentTab == HomeTabs.latest) {
      await VentsSetup().setupLatest();
      
    } else if (currentTab == HomeTabs.trending) {
      await VentsSetup().setupTrending();

    } else if (currentTab == HomeTabs.following) {
      await VentsSetup().setupFollowing();

    }

    await ActivityService().initializeActivities();

  }

  Future<void> _initializedStartupData() async {

    await ProfileDataSetup().setup(username: userProvider.user.username).then(
      (_) => _initializeHomeVents()
    );

    await localStorage.readThemeInformation().then(
      (theme) => ThemeUpdater(theme: theme).updateTheme()
    );

    globalThemeNotifier.value = GlobalAppTheme().buildAppTheme();

  }

  void _initializeSplashScreenTimer() async {

    final localUsername = (await localStorage.readAccountInformation())['username']!;

    if (localUsername.isNotEmpty) {
      splashScreenTimer = Timer(const Duration(milliseconds: 0), 
        () => _navigateToNextScreen()
      );

    } else {
      splashScreenTimer = Timer(const Duration(milliseconds: 1700),
        () => _navigateToNextScreen()
      );
      
    }
    
  }

  void _navigateToNextScreen() async {

    try {

      final localData = await localStorage.readAccountInformation();

      final username = localData['username']!;
      final email = localData['email']!;

      if (username.isEmpty) {
        NavigatePage.mainScreenPage();
        return;
      }

      final userSetup = UserData(username: username, email: email);

      userProvider.setUser(userSetup);      

      await _initializedStartupData().then(
        (_) => NavigatePage.homePage()
      );
      
      await _initializeQuickActions();

    } catch (_) {
      NavigatePage.mainScreenPage();
    }

  }

  @override
  void initState() {
    super.initState();
    _initializeSplashScreenTimer();
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