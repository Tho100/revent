import 'package:get_it/get_it.dart';
import 'package:revent/shared/provider/follow_suggestion_provider.dart';
import 'package:revent/shared/provider/navigation_provider.dart';
import 'package:revent/shared/provider/profile/info_provider.dart';
import 'package:revent/shared/provider/profile/posts_provider.dart';
import 'package:revent/shared/provider/profile/saved_provider.dart';
import 'package:revent/shared/provider/search/profiles_provider.dart';
import 'package:revent/shared/provider/search/posts_provider.dart';
import 'package:revent/shared/provider/user_provider.dart';
import 'package:revent/shared/provider/vent/active_vent_provider.dart';
import 'package:revent/shared/provider/vent/replies_provider.dart';
import 'package:revent/shared/provider/vent/liked_vent_provider.dart';
import 'package:revent/shared/provider/vent/saved_vent_provider.dart';
import 'package:revent/shared/provider/vent/comments_provider.dart';
import 'package:revent/shared/provider/vent/following_provider.dart';
import 'package:revent/shared/provider/vent/latest_provider.dart';
import 'package:revent/shared/provider/vent/trending_provider.dart';

extension GetItExtensions on GetIt {
  
  NavigationProvider get navigationProvider => get<NavigationProvider>();
  UserProvider get userProvider => get<UserProvider>();
  ProfileProvider get profileProvider => get<ProfileProvider>();

  VentLatestProvider get ventLatestProvider => get<VentLatestProvider>();
  VentTrendingProvider get ventTrendingProvider => get<VentTrendingProvider>();
  VentFollowingProvider get ventFollowingProvider => get<VentFollowingProvider>();
  CommentsProvider get ventCommentProvider => get<CommentsProvider>();
  ActiveVentProvider get activeVentProvider => get<ActiveVentProvider>();

  ProfilePostsProvider get profilePostsProvider => get<ProfilePostsProvider>();
  ProfileSavedProvider get profileSavedProvider => get<ProfileSavedProvider>();

  SearchPostsProvider get searchPostsProvider => get<SearchPostsProvider>();
  SearchAccountsProvider get searchAccountsProvider => get<SearchAccountsProvider>();

  LikedVentProvider get likedVentProvider => get<LikedVentProvider>();
  SavedVentProvider get savedVentProvider => get<SavedVentProvider>();

  FollowSuggestionProvider get followSuggestionProvider => get<FollowSuggestionProvider>();
  RepliesProvider get commentRepliesProvider => get<RepliesProvider>();
  
}