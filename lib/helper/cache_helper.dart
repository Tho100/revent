import 'dart:convert';

import 'package:revent/global/cache_names.dart';
import 'package:revent/shared/provider_mixins.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper with NavigationProviderService {

  Future<Map<String, dynamic>> getActivityCache() async {

    final prefs = await SharedPreferences.getInstance();

    final storedLikesJson = prefs.getString(CacheNames.postLikesCache) ?? '{}';
    final storedFollowersJson = prefs.getString(CacheNames.followersCache) ?? '{}';

    final storedLikes = jsonDecode(storedLikesJson);
    final storedFollowers = jsonDecode(storedFollowersJson);

    return {
      CacheNames.postLikesCache: storedLikes,
      CacheNames.followersCache: storedFollowers,
    };

  }
  
  Future<void> initializeCache({
    required Map<String, List<dynamic>> likesPostCache,
    required Map<String, List<dynamic>> followersCache,
  }) async {

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(CacheNames.postLikesCache, jsonEncode(likesPostCache));
    await prefs.setString(CacheNames.followersCache, jsonEncode(followersCache));

    navigationProvider.setBadgeVisible(false);

  }

  Future<void> clearActivityCache() async {

    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(CacheNames.postLikesCache);
    await prefs.remove(CacheNames.followersCache);
    await prefs.remove(CacheNames.unreadCache);

    navigationProvider.setBadgeVisible(false);
    
  }


}