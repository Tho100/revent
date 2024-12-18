import 'package:get_it/get_it.dart';
import 'package:revent/provider/navigation_provider.dart';
import 'package:revent/provider/profile/profile_data_provider.dart';
import 'package:revent/provider/profile/profile_posts_provider.dart';
import 'package:revent/provider/profile/profile_saved_provider.dart';
import 'package:revent/provider/search/search_accounts_provider.dart';
import 'package:revent/provider/search/search_posts_provider.dart';
import 'package:revent/provider/user_data_provider.dart';
import 'package:revent/provider/vent/active_vent_provider.dart';
import 'package:revent/provider/vent/liked_vent_data_provider.dart';
import 'package:revent/provider/vent/vent_comment_provider.dart';
import 'package:revent/provider/vent/vent_following_provider.dart';
import 'package:revent/provider/vent/vent_for_you_provider.dart';

extension GetItExtensions on GetIt {
  
  NavigationProvider get navigationProvider => get<NavigationProvider>();
  UserDataProvider get userProvider => get<UserDataProvider>();
  ProfileDataProvider get profileProvider => get<ProfileDataProvider>();

  VentForYouProvider get ventForYouProvider => get<VentForYouProvider>();
  VentFollowingProvider get ventFollowingProvider => get<VentFollowingProvider>();
  VentCommentProvider get ventCommentProvider => get<VentCommentProvider>();
  ActiveVentProvider get activeVentProvider => get<ActiveVentProvider>();

  ProfilePostsProvider get profilePostsProvider => get<ProfilePostsProvider>();
  ProfileSavedProvider get profileSavedProvider => get<ProfileSavedProvider>();

  SearchPostsProvider get searchPostsProvider => get<SearchPostsProvider>();
  SearchAccountsProvider get searchAccountsProvider => get<SearchAccountsProvider>();

  LikedVentProvider get likedVentProvider => get<LikedVentProvider>();

}