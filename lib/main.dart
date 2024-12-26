import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:revent/global/constant.dart';
import 'package:revent/pages/splash_screen_page.dart';
import 'package:revent/shared/provider/navigation_provider.dart';
import 'package:revent/shared/provider/profile/profile_posts_provider.dart';
import 'package:revent/shared/provider/profile/profile_saved_provider.dart';
import 'package:revent/shared/provider/search/search_accounts_provider.dart';
import 'package:revent/shared/provider/search/search_posts_provider.dart';
import 'package:revent/shared/provider/user_data_provider.dart';
import 'package:revent/shared/provider/profile/profile_provider.dart';
import 'package:revent/shared/provider/vent/active_vent_provider.dart';
import 'package:revent/shared/provider/vent/liked_vent_provider.dart';
import 'package:revent/shared/provider/vent/saved_vent_provider.dart';
import 'package:revent/shared/provider/vent/vent_comment_provider.dart';
import 'package:revent/shared/provider/vent/vent_for_you_provider.dart';
import 'package:revent/shared/provider/vent/vent_following_provider.dart';
import 'package:revent/shared/provider/vent/vent_trending_provider.dart';
import 'package:revent/shared/themes/app_theme.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.I;

void initializeLocators() {

  getIt.registerLazySingleton<NavigationProvider>(() => NavigationProvider());
  getIt.registerLazySingleton<UserProvider>(() => UserProvider());
  getIt.registerLazySingleton<VentForYouProvider>(() => VentForYouProvider());
  getIt.registerLazySingleton<VentFollowingProvider>(() => VentFollowingProvider());
  getIt.registerLazySingleton<VentTrendingProvider>(() => VentTrendingProvider());
  getIt.registerLazySingleton<VentCommentProvider>(() => VentCommentProvider());
  getIt.registerLazySingleton<ActiveVentProvider>(() => ActiveVentProvider());
  getIt.registerLazySingleton<ProfileProvider>(() => ProfileProvider());
  getIt.registerLazySingleton<ProfilePostsProvider>(() => ProfilePostsProvider());
  getIt.registerLazySingleton<ProfileSavedProvider>(() => ProfileSavedProvider());
  getIt.registerLazySingleton<SearchPostsProvider>(() => SearchPostsProvider());
  getIt.registerLazySingleton<SearchAccountsProvider>(() => SearchAccountsProvider());
  getIt.registerLazySingleton<LikedVentProvider>(() => LikedVentProvider());
  getIt.registerLazySingleton<SavedVentProvider>(() => SavedVentProvider());

}

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  initializeLocators();

  final providers = [
    ChangeNotifierProvider(create: (_) => getIt<VentForYouProvider>()),
    ChangeNotifierProvider(create: (_) => getIt<VentFollowingProvider>()),
    ChangeNotifierProvider(create: (_) => getIt<VentTrendingProvider>()),
    ChangeNotifierProvider(create: (_) => getIt<NavigationProvider>()),
    ChangeNotifierProvider(create: (_) => getIt<UserProvider>()),
    ChangeNotifierProvider(create: (_) => getIt<ProfileProvider>()),
    ChangeNotifierProvider(create: (_) => getIt<ProfilePostsProvider>()),
    ChangeNotifierProvider(create: (_) => getIt<ProfileSavedProvider>()),
    ChangeNotifierProvider(create: (_) => getIt<VentCommentProvider>()),
    ChangeNotifierProvider(create: (_) => getIt<ActiveVentProvider>()),
    ChangeNotifierProvider(create: (_) => getIt<SearchPostsProvider>()),
    ChangeNotifierProvider(create: (_) => getIt<SearchAccountsProvider>()),
    ChangeNotifierProvider(create: (_) => getIt<LikedVentProvider>()),
    ChangeNotifierProvider(create: (_) => getIt<SavedVentProvider>()),
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