import 'dart:convert';

import 'package:revent/shared/provider_mixins.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper with NavigationProviderService {

  final _likedPostCacheName = 'post_like_cache';
  final _followersCacheName = 'followers_cache';

  Future<Map<String, dynamic>> getNotificationCache() async {

    final prefs = await SharedPreferences.getInstance();

    final storedLikesJson = prefs.getString('post_like_cache') ?? '{}';
    final storedFollowersJson = prefs.getString('followers_cache') ?? '{}';

    final storedLikes = jsonDecode(storedLikesJson);
    final storedFollowers = jsonDecode(storedFollowersJson);

    return {
      'post_likes_cache': storedLikes,
      'followers_cache': storedFollowers,
    };

  }
  
  Future<void> initializeCache({
    required Map<String, List<dynamic>> likesPostCache,
    required Map<String, List<dynamic>> followersCache,
  }) async {

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_likedPostCacheName, jsonEncode(likesPostCache));
    await prefs.setString(_followersCacheName, jsonEncode(followersCache));

    navigationProvider.setBadgeVisible(false);

  }

  Future<void> clearNotificationCache() async {

    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_likedPostCacheName);
    await prefs.remove(_followersCacheName);
    await prefs.remove('has_unread_notifications');

    navigationProvider.setBadgeVisible(false);
    
  }


}