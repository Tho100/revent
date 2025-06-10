import 'dart:convert';

import 'package:revent/helper/providers_service.dart';
import 'package:revent/service/query/notification/follower_notification_getter.dart';
import 'package:revent/service/query/notification/post_notification_getter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService with NavigationProviderService {

  final _likedPostCacheName = 'post_like_cache';
  final _followersCacheName = 'followers_cache';
  final _unreadCacheName = 'has_unread_notifications';

  Future<void> initializeNotifications() async {

    final prefs = await SharedPreferences.getInstance();

    final hasNewNotification = await _notifyNewNotification();

    if (hasNewNotification) {
      await prefs.setBool(_unreadCacheName, true);
    }

    final showBadge = prefs.getBool(_unreadCacheName) ?? false;

    navigationProvider.setBadgeVisible(showBadge);

  }

  Future<void> markNotificationAsRead() async {
    
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(_unreadCacheName, false);

    final currentLikes = await VentPostNotificationGetter().getPostLikes();
    final currentFollowers = await NewFollowerNotificationGetter().getFollowers();

    final titles = currentLikes['title']!;
    final likeCounts = currentLikes['like_count']!;
    final likedAt = currentLikes['liked_at']!;

    final followers = currentFollowers['followers']!;
    final followedAt = currentFollowers['followed_at']!;

    final postLikesCache = <String, List<dynamic>>{};
    final followersCache = <String, List<dynamic>>{};

    for (int i = 0; i < titles.length; i++) {
      postLikesCache[titles[i]] = [likeCounts[i], likedAt[i]];
    }

    for (int i = 0; i < followers.length; i++) {
      followersCache[followers[i]] = [followedAt[i]];
    }

    await _initializeCache(
      prefs: prefs, 
      cacheName: _likedPostCacheName, 
      cacheData: postLikesCache
    );

    await _initializeCache(
      prefs: prefs, 
      cacheName: _followersCacheName, 
      cacheData: followersCache
    );

  }

  Future<void> _initializeCache({
    required SharedPreferences prefs,
    required String cacheName, 
    required Map<String, List<dynamic>> cacheData
  }) async {

    await prefs.setString(cacheName, jsonEncode(cacheData)).then(
      (_) => navigationProvider.setBadgeVisible(false)
    );

  }

  Future<bool> _notifyNewNotification() async {

    final currentLikes = await VentPostNotificationGetter().getPostLikes();
    final currentFollowers = await NewFollowerNotificationGetter().getFollowers();

    final prefs = await SharedPreferences.getInstance();

    final storedLikesJson = prefs.getString(_likedPostCacheName) ?? '{}';
    final storedLikes = jsonDecode(storedLikesJson);

    final storedFollowersJson = prefs.getString(_followersCacheName) ?? '{}';
    final storedFollowers = jsonDecode(storedFollowersJson);

    bool shouldNotify = false;

    final titles = currentLikes['title']!;
    final likeCounts = currentLikes['like_count']!;

    for (int i = 0; i < titles.length; i++) {
      
      final title = titles[i];
      final newCount = likeCounts[i];

      final storedLikeEntry = storedLikes[title];
      final oldCount = (storedLikeEntry is List && storedLikeEntry.isNotEmpty)
        ? (storedLikeEntry[0] as num?)?.toInt() ?? 0 : 0; 

      if (newCount != oldCount) {
        shouldNotify = true;
        break;
      }

    }

    final previousFollowerCount = storedFollowers.keys.length;
    final currentFollowerCount = currentFollowers['followers']?.length ?? 0;

    if (currentFollowerCount > previousFollowerCount) {
      shouldNotify = true;
    }

    return shouldNotify;

  }

}