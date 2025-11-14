import 'dart:convert';

import 'package:revent/global/cache_names.dart';
import 'package:revent/shared/provider_mixins.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper with NavigationProviderService {

  Future<Map<String, dynamic>> getActivityCache() async {

    final prefs = await SharedPreferences.getInstance();

    final storedLikesJson = prefs.getString(CacheNames.activityPostLikesCache) ?? '{}';
    final storedFollowersJson = prefs.getString(CacheNames.activityFollowersCache) ?? '{}';

    final storedLikes = jsonDecode(storedLikesJson);
    final storedFollowers = jsonDecode(storedFollowersJson);

    return {
      CacheNames.activityPostLikesCache: storedLikes,
      CacheNames.activityFollowersCache: storedFollowers,
    };

  }
  
  Future<void> initializeCache({
    required Map<String, List<dynamic>> likesPostCache,
    required Map<String, List<dynamic>> activityFollowersCache,
  }) async {

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(CacheNames.activityPostLikesCache, jsonEncode(likesPostCache));
    await prefs.setString(CacheNames.activityFollowersCache, jsonEncode(activityFollowersCache));

    navigationProvider.setActivityBadgeVisible(false);

  }

  Future<void> clearActivityCache() async {

    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(CacheNames.activityPostLikesCache);
    await prefs.remove(CacheNames.activityFollowersCache);
    await prefs.remove(CacheNames.activityHasUnread);

    navigationProvider.setActivityBadgeVisible(false);
    
  }

  Future<void> clearFollowingFeedCache() async {

    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(CacheNames.followingHasSeen);
    await prefs.remove(CacheNames.followingLastPostId);

    navigationProvider.setFollowingFeedBadgeVisible(false);
    
  }

}