import 'package:revent/main.dart';
import 'package:revent/shared/provider/navigation_provider.dart';
import 'package:revent/shared/provider/profile/profile_provider.dart';
import 'package:revent/shared/provider/search/search_accounts_provider.dart';
import 'package:revent/shared/provider/search/search_posts_provider.dart';
import 'package:revent/shared/provider/user_provider.dart';
import 'package:revent/shared/provider/vent/active_vent_provider.dart';
import 'package:revent/shared/provider/vent/vent_following_provider.dart';
import 'package:revent/shared/provider/vent/vent_for_you_provider.dart';
import 'package:revent/shared/provider/vent/vent_trending_provider.dart';

mixin UserProfileProviderService {

  UserProvider get userProvider => getIt<UserProvider>();
  ProfileProvider get profileProvider => getIt<ProfileProvider>();

}

mixin VentProviderService {

  VentForYouProvider get forVentYouProvider => getIt<VentForYouProvider>();
  VentTrendingProvider get trendingVentProvider => getIt<VentTrendingProvider>();
  VentFollowingProvider get followingVentProvider => getIt<VentFollowingProvider>();
  ActiveVentProvider get activeVentProvider => getIt<ActiveVentProvider>();

}

mixin SearchProviderService {

  SearchPostsProvider get searchPostsProvider => getIt<SearchPostsProvider>();
  SearchAccountsProvider get searchAccountsProvider => getIt<SearchAccountsProvider>();

}

mixin NavigationProviderService {
  
  NavigationProvider get navigationProvider => getIt<NavigationProvider>();

}