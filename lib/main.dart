import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:revent/pages/splash_screen_page.dart';
import 'package:revent/provider/navigation_provider.dart';
import 'package:revent/provider/vent_data_provider.dart';
import 'package:revent/themes/theme_color.dart';
import 'package:get_it/get_it.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void initializeLocators() {
  final locators = GetIt.instance;
  locators.registerLazySingleton<VentDataProvider>(() => VentDataProvider());
  locators.registerLazySingleton<NavigationProvider>(() => NavigationProvider());
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  initializeLocators();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => GetIt.instance<VentDataProvider>()),
        ChangeNotifierProvider(create: (context) => GetIt.instance<NavigationProvider>())
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
      theme: ThemeData(
        actionIconTheme: ActionIconThemeData(
          backButtonIconBuilder: (BuildContext context) => const Icon(CupertinoIcons.chevron_back),
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