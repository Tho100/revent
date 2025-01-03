import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/main.dart';

class AppRoute {

  static final _navigation = getIt.navigationProvider;

  static const home = '/home/';
  static const myProfile = '/profile/my_profile/';
  static const userProfile = '/profile/user_profile/';
  static const searchResults = '/search/search_results/';
  static const likedPosts = '/settings/liked_posts/';
  static const savedPosts = '/settings/saved_posts/';

  static bool get isOnProfile =>
    _navigation.currentRoute == myProfile || 
    _navigation.currentRoute == userProfile;
  
}