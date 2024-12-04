import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:revent/global/constant.dart';
import 'package:revent/pages/splash_screen_page.dart';
import 'package:revent/provider/navigation_provider.dart';
import 'package:revent/provider/profile/profile_posts_provider.dart';
import 'package:revent/provider/profile/profile_saved_provider.dart';
import 'package:revent/provider/user_data_provider.dart';
import 'package:revent/provider/profile/profile_data_provider.dart';
import 'package:revent/provider/vent/active_vent_provider.dart';
import 'package:revent/provider/vent/vent_comment_provider.dart';
import 'package:revent/provider/vent/vent_data_provider.dart';
import 'package:revent/provider/vent/vent_following_data_provider.dart';
import 'package:revent/themes/theme_color.dart';
import 'package:get_it/get_it.dart';

void initializeLocators() {
  final locators = GetIt.instance;
  locators.registerLazySingleton<NavigationProvider>(() => NavigationProvider());
  locators.registerLazySingleton<UserDataProvider>(() => UserDataProvider());
  locators.registerLazySingleton<VentDataProvider>(() => VentDataProvider());
  locators.registerLazySingleton<VentFollowingDataProvider>(() => VentFollowingDataProvider());
  locators.registerLazySingleton<VentCommentProvider>(() => VentCommentProvider());
  locators.registerLazySingleton<ActiveVentProvider>(() => ActiveVentProvider());
  locators.registerLazySingleton<ProfileDataProvider>(() => ProfileDataProvider());
  locators.registerLazySingleton<ProfilePostsProvider>(() => ProfilePostsProvider());
  locators.registerLazySingleton<ProfileSavedProvider>(() => ProfileSavedProvider());
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  initializeLocators();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GetIt.instance<VentDataProvider>()),
        ChangeNotifierProvider(create: (_) => GetIt.instance<VentFollowingDataProvider>()),
        ChangeNotifierProvider(create: (_) => GetIt.instance<NavigationProvider>()),
        ChangeNotifierProvider(create: (_) => GetIt.instance<UserDataProvider>()),
        ChangeNotifierProvider(create: (_) => GetIt.instance<ProfileDataProvider>()),
        ChangeNotifierProvider(create: (_) => GetIt.instance<ProfilePostsProvider>()),
        ChangeNotifierProvider(create: (_) => GetIt.instance<ProfileSavedProvider>()),
        ChangeNotifierProvider(create: (_) => GetIt.instance<VentCommentProvider>()),
        ChangeNotifierProvider(create: (_) => GetIt.instance<ActiveVentProvider>()),
      ],
      child: const MainRun(),
    ),
  );
}

class MainRun extends StatelessWidget {

  const MainRun({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      scaffoldMessengerKey: scaffoldMessengerKey,
      theme: ThemeData(
        actionIconTheme: ActionIconThemeData(
          backButtonIconBuilder: (_) => const Icon(CupertinoIcons.chevron_back),
        ),
        scaffoldBackgroundColor: ThemeColor.black,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: ThemeColor.black,
        )
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen()
    );
  }

}