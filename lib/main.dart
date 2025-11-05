import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:revent/global/app_keys.dart';
import 'package:revent/pages/splash_screen_page.dart';
import 'package:revent/shared/provider/follow_suggestion_provider.dart';
import 'package:revent/shared/provider/navigation_provider.dart';
import 'package:revent/shared/provider/profile/posts_provider.dart';
import 'package:revent/shared/provider/profile/saved_provider.dart';
import 'package:revent/shared/provider/search/profiles_provider.dart';
import 'package:revent/shared/provider/search/posts_provider.dart';
import 'package:revent/shared/provider/user_provider.dart';
import 'package:revent/shared/provider/profile/info_provider.dart';
import 'package:revent/shared/provider/vent/active_vent_provider.dart';
import 'package:revent/shared/provider/vent/replies_provider.dart';
import 'package:revent/shared/provider/vent/liked_vent_provider.dart';
import 'package:revent/shared/provider/vent/saved_vent_provider.dart';
import 'package:revent/shared/provider/vent/comments_provider.dart';
import 'package:revent/shared/provider/vent/tags_provider.dart';
import 'package:revent/shared/provider/vent/latest_provider.dart';
import 'package:revent/shared/provider/vent/following_provider.dart';
import 'package:revent/shared/provider/vent/trending_provider.dart';
import 'package:revent/shared/themes/app_theme.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.I;

final globalThemeNotifier = ValueNotifier<ThemeData>(
  GlobalAppTheme().buildAppTheme()
);

void _initializeSystemOverlayStyle() {

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent,
    statusBarColor: Colors.transparent,
  ));

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

}

void _initializeLocators() {

  getIt.registerLazySingleton<NavigationProvider>(() => NavigationProvider());
  getIt.registerLazySingleton<UserProvider>(() => UserProvider());
  getIt.registerLazySingleton<VentLatestProvider>(() => VentLatestProvider());
  getIt.registerLazySingleton<VentFollowingProvider>(() => VentFollowingProvider());
  getIt.registerLazySingleton<VentTrendingProvider>(() => VentTrendingProvider());
  getIt.registerLazySingleton<CommentsProvider>(() => CommentsProvider());
  getIt.registerLazySingleton<RepliesProvider>(() => RepliesProvider());
  getIt.registerLazySingleton<ActiveVentProvider>(() => ActiveVentProvider());
  getIt.registerLazySingleton<ProfileProvider>(() => ProfileProvider());
  getIt.registerLazySingleton<ProfilePostsProvider>(() => ProfilePostsProvider());
  getIt.registerLazySingleton<ProfileSavedProvider>(() => ProfileSavedProvider());
  getIt.registerLazySingleton<SearchPostsProvider>(() => SearchPostsProvider());
  getIt.registerLazySingleton<SearchAccountsProvider>(() => SearchAccountsProvider());
  getIt.registerLazySingleton<LikedVentProvider>(() => LikedVentProvider());
  getIt.registerLazySingleton<SavedVentProvider>(() => SavedVentProvider());
  getIt.registerLazySingleton<FollowSuggestionProvider>(() => FollowSuggestionProvider());
  getIt.registerLazySingleton<TagsProvider>(() => TagsProvider());

}

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  _initializeSystemOverlayStyle();

  await dotenv.load(fileName: '.env').then(
    (_) => _initializeLocators()
  );

  final providers = [
    ChangeNotifierProvider(create: (_) => getIt<VentLatestProvider>()),
    ChangeNotifierProvider(create: (_) => getIt<VentFollowingProvider>()),
    ChangeNotifierProvider(create: (_) => getIt<VentTrendingProvider>()),
    ChangeNotifierProvider(create: (_) => getIt<NavigationProvider>()),
    ChangeNotifierProvider(create: (_) => getIt<UserProvider>()),
    ChangeNotifierProvider(create: (_) => getIt<ProfileProvider>()),
    ChangeNotifierProvider(create: (_) => getIt<ProfilePostsProvider>()),
    ChangeNotifierProvider(create: (_) => getIt<ProfileSavedProvider>()),
    ChangeNotifierProvider(create: (_) => getIt<CommentsProvider>()),
    ChangeNotifierProvider(create: (_) => getIt<RepliesProvider>()),
    ChangeNotifierProvider(create: (_) => getIt<ActiveVentProvider>()),
    ChangeNotifierProvider(create: (_) => getIt<SearchPostsProvider>()),
    ChangeNotifierProvider(create: (_) => getIt<SearchAccountsProvider>()),
    ChangeNotifierProvider(create: (_) => getIt<LikedVentProvider>()),
    ChangeNotifierProvider(create: (_) => getIt<SavedVentProvider>()),
    ChangeNotifierProvider(create: (_) => getIt<FollowSuggestionProvider>()),
    ChangeNotifierProvider(create: (_) => getIt<TagsProvider>()),
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
    return ValueListenableBuilder(
      valueListenable: globalThemeNotifier,
      builder: (_, themeData, __) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorKey: AppKeys.navigatorKey,
          scaffoldMessengerKey: AppKeys.scaffoldMessengerKey,
          theme: themeData,
          home: const SplashScreen()
        );
      },
    );
  }

}