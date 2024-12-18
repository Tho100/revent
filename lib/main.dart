import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:revent/global/constant.dart';
import 'package:revent/pages/splash_screen_page.dart';
import 'package:revent/provider/navigation_provider.dart';
import 'package:revent/provider/profile/profile_posts_provider.dart';
import 'package:revent/provider/profile/profile_saved_provider.dart';
import 'package:revent/provider/search/search_accounts_provider.dart';
import 'package:revent/provider/search/search_posts_provider.dart';
import 'package:revent/provider/user_data_provider.dart';
import 'package:revent/provider/profile/profile_data_provider.dart';
import 'package:revent/provider/vent/active_vent_provider.dart';
import 'package:revent/provider/vent/liked_vent_data_provider.dart';
import 'package:revent/provider/vent/vent_comment_provider.dart';
import 'package:revent/provider/vent/vent_for_you_provider.dart';
import 'package:revent/provider/vent/vent_following_data_provider.dart';
import 'package:revent/themes/app_theme.dart';
import 'package:get_it/get_it.dart';

void initializeLocators() {

  final getIt = GetIt.instance;

  getIt.registerLazySingleton<NavigationProvider>(() => NavigationProvider());
  getIt.registerLazySingleton<UserDataProvider>(() => UserDataProvider());
  getIt.registerLazySingleton<VentForYouProvider>(() => VentForYouProvider());
  getIt.registerLazySingleton<VentFollowingDataProvider>(() => VentFollowingDataProvider());
  getIt.registerLazySingleton<VentCommentProvider>(() => VentCommentProvider());
  getIt.registerLazySingleton<ActiveVentProvider>(() => ActiveVentProvider());
  getIt.registerLazySingleton<ProfileDataProvider>(() => ProfileDataProvider());
  getIt.registerLazySingleton<ProfilePostsProvider>(() => ProfilePostsProvider());
  getIt.registerLazySingleton<ProfileSavedProvider>(() => ProfileSavedProvider());
  getIt.registerLazySingleton<SearchPostsProvider>(() => SearchPostsProvider());
  getIt.registerLazySingleton<SearchAccountsProvider>(() => SearchAccountsProvider());
  getIt.registerLazySingleton<LikedVentDataProvider>(() => LikedVentDataProvider());

}

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  initializeLocators();

  final getIt = GetIt.instance;

  final providers = [
    ChangeNotifierProvider(create: (_) => getIt<VentForYouProvider>()),
    ChangeNotifierProvider(create: (_) => getIt<VentFollowingDataProvider>()),
    ChangeNotifierProvider(create: (_) => getIt<NavigationProvider>()),
    ChangeNotifierProvider(create: (_) => getIt<UserDataProvider>()),
    ChangeNotifierProvider(create: (_) => getIt<ProfileDataProvider>()),
    ChangeNotifierProvider(create: (_) => getIt<ProfilePostsProvider>()),
    ChangeNotifierProvider(create: (_) => getIt<ProfileSavedProvider>()),
    ChangeNotifierProvider(create: (_) => getIt<VentCommentProvider>()),
    ChangeNotifierProvider(create: (_) => getIt<ActiveVentProvider>()),
    ChangeNotifierProvider(create: (_) => getIt<SearchPostsProvider>()),
    ChangeNotifierProvider(create: (_) => getIt<SearchAccountsProvider>()),
    ChangeNotifierProvider(create: (_) => getIt<LikedVentDataProvider>()),
  ];

  runApp(
    MultiProvider(
      providers: providers,
      child: const MainRun(),
    ),
  );

}

class MainRun extends StatelessWidget {

  const MainRun({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      scaffoldMessengerKey: scaffoldMessengerKey,
      theme: GlobalAppTheme().buildAppTheme(),
      home: const SplashScreen()
    );
  }

}