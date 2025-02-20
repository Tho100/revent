import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/main.dart';

enum AppRoute {

  home('/home/'),
  myProfile('/profile/my_profile/'),
  userProfile('/profile/user_profile/'),
  searchResults('/search/search_results/'),
  likedPosts('/settings/liked_posts/'),
  savedPosts('/settings/saved_posts/');

  final String path;

  const AppRoute(this.path);

}

class RouteHelper {

  static final _navigation = getIt.navigationProvider;

  static bool get isOnProfile =>
    _navigation.currentRoute == AppRoute.myProfile.path ||
    _navigation.currentRoute == AppRoute.userProfile.path;
    
}