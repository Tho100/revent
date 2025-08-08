import 'package:flutter/material.dart';

class AppKeys {

  /// Global key for accessing the [ScaffoldMessengerState] from anywhere in the app.
  /// Use for showing snackbars outside widget context.

  static final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  /// Global key for accessing the [NavigatorState] globally.
  /// Use for navigation outside of BuildContext.
  
  static final navigatorKey = GlobalKey<NavigatorState>();

}
