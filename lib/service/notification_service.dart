import 'dart:convert';

import 'package:revent/helper/providers_service.dart';
import 'package:revent/service/query/notification/follower_notification_getter.dart';
import 'package:revent/service/query/notification/post_notification_getter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService with NavigationProviderService {

  Future<void> initializeNotifications() async {

    final prefs = await SharedPreferences.getInstance();

    final hasNewNotification = await _notifyNewNotification();

    if (hasNewNotification) {
      await prefs.setBool('hasUnreadNotifications', true);
    }

    final showBadge = prefs.getBool('hasUnreadNotifications') ?? false;

    navigationProvider.setBadgeVisible(showBadge);

  }

  Future<void> markNotificationAsRead() async {
    
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('hasUnreadNotifications', false);

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

    await prefs.setString('post_like_cache', jsonEncode(postLikesCache)).then(
      (_) => navigationProvider.setBadgeVisible(false)
    );
// TODO: Create separated _initializeCache(String cacheName, Map<String, List<dynamic>>) function to simplify thhis
    await prefs.setString('followers_cache', jsonEncode(followersCache)).then(
      (_) => navigationProvider.setBadgeVisible(false)
    );

  }

  Future<bool> _notifyNewNotification() async {

    final currentLikes = await VentPostNotificationGetter().getPostLikes();
    final currentFollowers = await NewFollowerNotificationGetter().getFollowers();

    final prefs = await SharedPreferences.getInstance();

    final storedLikesJson = prefs.getString('post_like_cache') ?? '{}';
    final storedLikes = jsonDecode(storedLikesJson);

    final storedFollowersJson = prefs.getString('followers_cache') ?? '{}';
    final storedFollowers = jsonDecode(storedFollowersJson);

    bool shouldNotify = false;

    final titles = currentLikes['title']!;
    final likeCounts = currentLikes['like_count']!;

    for (int i = 0; i < titles.length; i++) {

      final title = titles[i];
      final newCount = likeCounts[i];

      final oldCount = storedLikes[title][0]?.toInt() ?? 0;

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