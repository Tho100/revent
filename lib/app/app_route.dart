import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/main.dart';

enum AppRoute {
  home,
  myProfile,
  userProfile,
  searchResults,
  profileLikedPosts,
  profileSavedPosts
}

class RouteHelper {

  static final _navigation = getIt.navigationProvider;

  static bool get isOnProfile =>
    _navigation.currentRoute == AppRoute.myProfile ||
    _navigation.currentRoute == AppRoute.userProfile;

}