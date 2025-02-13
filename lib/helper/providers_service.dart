import 'package:revent/main.dart';
import 'package:revent/shared/provider/follow_suggestion_provider.dart';
import 'package:revent/shared/provider/navigation_provider.dart';
import 'package:revent/shared/provider/profile/profile_posts_provider.dart';
import 'package:revent/shared/provider/profile/profile_provider.dart';
import 'package:revent/shared/provider/profile/profile_saved_provider.dart';
import 'package:revent/shared/provider/search/search_accounts_provider.dart';
import 'package:revent/shared/provider/search/search_posts_provider.dart';
import 'package:revent/shared/provider/user_provider.dart';
import 'package:revent/shared/provider/vent/active_vent_provider.dart';
import 'package:revent/shared/provider/vent/comments_provider.dart';
import 'package:revent/shared/provider/vent/liked_vent_provider.dart';
import 'package:revent/shared/provider/vent/replies_provider.dart';
import 'package:revent/shared/provider/vent/saved_vent_provider.dart';
import 'package:revent/shared/provider/vent/vent_following_provider.dart';
import 'package:revent/shared/provider/vent/vent_for_you_provider.dart';
import 'package:revent/shared/provider/vent/vent_trending_provider.dart';

mixin UserProfileProviderService {

  UserProvider get userProvider => getIt<UserProvider>();
  ProfileProvider get profileProvider => getIt<ProfileProvider>();

}

mixin VentProviderService {

  VentForYouProvider get forYouVentProvider => getIt<VentForYouProvider>();
  VentTrendingProvider get trendingVentProvider => getIt<VentTrendingProvider>();
  VentFollowingProvider get followingVentProvider => getIt<VentFollowingProvider>();
  ActiveVentProvider get activeVentProvider => getIt<ActiveVentProvider>();

}

mixin SearchProviderService {

  SearchPostsProvider get searchPostsProvider => getIt<SearchPostsProvider>();
  SearchAccountsProvider get searchAccountsProvider => getIt<SearchAccountsProvider>();

}

mixin ProfilePostsProviderService {

  ProfilePostsProvider get profilePostsProvider => getIt<ProfilePostsProvider>();
  ProfileSavedProvider get profileSavedProvider => getIt<ProfileSavedProvider>();

}

mixin LikedSavedProviderService {

  LikedVentProvider get likedVentProvider => getIt<LikedVentProvider>();
  SavedVentProvider get savedVentProvider => getIt<SavedVentProvider>();

}

mixin NavigationProviderService {
  
  NavigationProvider get navigationProvider => getIt<NavigationProvider>();

}

mixin CommentsProviderService {

  CommentsProvider get commentsProvider => getIt<CommentsProvider>();

}

mixin RepliesProviderService {

  RepliesProvider get repliesProvider => getIt<RepliesProvider>();

}

mixin FollowSuggestionProviderService {

  FollowSuggestionProvider get followSuggestionProvider => getIt<FollowSuggestionProvider>();

}