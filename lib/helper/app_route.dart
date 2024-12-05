import 'package:get_it/get_it.dart';
import 'package:revent/provider/navigation_provider.dart';

class AppRoute {

  static final _navigation = GetIt.instance<NavigationProvider>();

  static const home = '/home/';
  static const myProfile = '/profile/my_profile/';
  static const userProfile = '/profile/user_profile/';

  static bool get isOnProfile =>
      _navigation.currentRoute == myProfile || 
      _navigation.currentRoute == userProfile;
  
}