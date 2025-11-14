import 'package:revent/global/cache_names.dart';
import 'package:revent/shared/api/api_client.dart';
import 'package:revent/shared/api/api_path.dart';
import 'package:revent/shared/provider_mixins.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FollowingFeedService with 
  UserProfileProviderService, 
  NavigationProviderService {

  Future<void> initializeFollowingFeedInfo() async {
    
    if (profileProvider.profile.following == 0) {
      navigationProvider.setFollowingFeedBadgeVisible(false);
      return;
    }

    final prefs = await SharedPreferences.getInstance();

    final latestPostId = await _getLatestPostId();

    final info = await _loadFeedInfo();

    final lastPostId = info[CacheNames.followingLastPostId];
    final hasSeen = info[CacheNames.followingHasSeen];

    final showBadge = (latestPostId != lastPostId) || !hasSeen;

    await prefs.setInt(CacheNames.followingLastPostId, latestPostId);

    if (latestPostId != lastPostId) {
      await prefs.setBool(CacheNames.followingHasSeen, false);
    }

    navigationProvider.setFollowingFeedBadgeVisible(showBadge);

  }

  Future<void> setHasSeen() async {

    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(CacheNames.followingHasSeen, true);

    navigationProvider.setFollowingFeedBadgeVisible(false);

  }

  Future<Map<String, dynamic>> _loadFeedInfo() async {
    
    final prefs = await SharedPreferences.getInstance();

    final lastPostId = prefs.getInt(CacheNames.followingLastPostId) ?? 0;
    final hasSeen = prefs.getBool(CacheNames.followingHasSeen) ?? false;

    return {
      CacheNames.followingLastPostId: lastPostId,
      CacheNames.followingHasSeen: hasSeen
    };
    
  }

  Future<int> _getLatestPostId() async {

    final response = await ApiClient.get(ApiPath.userFollowingLatestPostId, userProvider.user.username);

    return response.body!['post_id'] ?? 0;

  }

}