import 'package:revent/main.dart';
import 'package:revent/shared/provider/follow_suggestion_provider.dart';
import 'package:revent/shared/provider/navigation_provider.dart';
import 'package:revent/shared/provider/profile/posts_provider.dart';
import 'package:revent/shared/provider/profile/info_provider.dart';
import 'package:revent/shared/provider/profile/saved_provider.dart';
import 'package:revent/shared/provider/search/profiles_provider.dart';
import 'package:revent/shared/provider/search/posts_provider.dart';
import 'package:revent/shared/provider/user_provider.dart';
import 'package:revent/shared/provider/vent/active_vent_provider.dart';
import 'package:revent/shared/provider/vent/comments_provider.dart';
import 'package:revent/shared/provider/vent/liked_vent_provider.dart';
import 'package:revent/shared/provider/vent/replies_provider.dart';
import 'package:revent/shared/provider/vent/saved_vent_provider.dart';
import 'package:revent/shared/provider/vent/tags_provider.dart';
import 'package:revent/shared/provider/vent/following_provider.dart';
import 'package:revent/shared/provider/vent/latest_provider.dart';
import 'package:revent/shared/provider/vent/trending_provider.dart';

mixin UserProfileProviderService {

  UserProvider get userProvider => getIt<UserProvider>();
  ProfileProvider get profileProvider => getIt<ProfileProvider>();

}

mixin VentProviderService {

  VentLatestProvider get latestVentProvider => getIt<VentLatestProvider>();
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

mixin TagsProviderService { 

  TagsProvider get tagsProvider => getIt<TagsProvider>();

}