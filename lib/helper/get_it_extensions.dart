import 'package:get_it/get_it.dart';
import 'package:revent/shared/provider/navigation_provider.dart';
import 'package:revent/shared/provider/profile/profile_provider.dart';
import 'package:revent/shared/provider/profile/profile_posts_provider.dart';
import 'package:revent/shared/provider/profile/profile_saved_provider.dart';
import 'package:revent/shared/provider/search/search_accounts_provider.dart';
import 'package:revent/shared/provider/search/search_posts_provider.dart';
import 'package:revent/shared/provider/user_data_provider.dart';
import 'package:revent/shared/provider/vent/active_vent_provider.dart';
import 'package:revent/shared/provider/vent/liked_vent_provider.dart';
import 'package:revent/shared/provider/vent/saved_vent_provider.dart';
import 'package:revent/shared/provider/vent/vent_comment_provider.dart';
import 'package:revent/shared/provider/vent/vent_following_provider.dart';
import 'package:revent/shared/provider/vent/vent_for_you_provider.dart';
import 'package:revent/shared/provider/vent/vent_trending_provider.dart';

extension GetItExtensions on GetIt {
  
  NavigationProvider get navigationProvider => get<NavigationProvider>();
  UserProvider get userProvider => get<UserProvider>();
  ProfileProvider get profileProvider => get<ProfileProvider>();

  VentForYouProvider get ventForYouProvider => get<VentForYouProvider>();
  VentTrendingProvider get ventTrendingProvider => get<VentTrendingProvider>();
  VentFollowingProvider get ventFollowingProvider => get<VentFollowingProvider>();
  VentCommentProvider get ventCommentProvider => get<VentCommentProvider>();
  ActiveVentProvider get activeVentProvider => get<ActiveVentProvider>();

  ProfilePostsProvider get profilePostsProvider => get<ProfilePostsProvider>();
  ProfileSavedProvider get profileSavedProvider => get<ProfileSavedProvider>();

  SearchPostsProvider get searchPostsProvider => get<SearchPostsProvider>();
  SearchAccountsProvider get searchAccountsProvider => get<SearchAccountsProvider>();

  LikedVentProvider get likedVentProvider => get<LikedVentProvider>();
  SavedVentProvider get savedVentProvider => get<SavedVentProvider>();

}