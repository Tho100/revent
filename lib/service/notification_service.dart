import 'package:revent/global/cache_names.dart';
import 'package:revent/helper/cache_helper.dart';
import 'package:revent/service/query/general/notifications_getter.dart';
import 'package:revent/shared/provider_mixins.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService with NavigationProviderService {

  final notificationsGetter = NotificationsGetter();

  Future<void> initializeNotifications({bool isLogin = false}) async {

    final prefs = await SharedPreferences.getInstance();

    if (isLogin) {

      await markNotificationAsRead(isLogin: true).then(
        (showBadge) => prefs.setBool(CacheNames.unreadCache, showBadge)
      );

    } else {

      final hasNewNotification = await _notifyNewNotification();

      if (hasNewNotification) {
        await prefs.setBool(CacheNames.unreadCache, true);
      }

    }

    final showBadge = prefs.getBool(CacheNames.unreadCache) ?? false;

    navigationProvider.setBadgeVisible(showBadge);

  }

  Future<bool> markNotificationAsRead({bool isLogin = false}) async {

    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(CacheNames.unreadCache, false);

    final currentLikes = await notificationsGetter.getUserPostsWithRecentLikes();
    final currentFollowers = await notificationsGetter.getUserFollowers();

    final titles = currentLikes['title']!;
    final likeCounts = currentLikes['like_count']!;
    final likedAt = currentLikes['liked_at']!;

    final followers = currentFollowers['followers']!;
    final followedAt = currentFollowers['followed_at']!;

    final oldCache = await CacheHelper().getNotificationCache();

    final postLikesCache = Map<String, List<dynamic>>.from(oldCache[CacheNames.postLikesCache]);
    final followersCache = Map<String, List<dynamic>>.from(oldCache[CacheNames.followersCache]);

    for (int i = 0; i < titles.length; i++) {
      postLikesCache[titles[i]] = [likeCounts[i], likedAt[i]];
    }

    for (int i = 0; i < followers.length; i++) {
      followersCache[followers[i]] = [followedAt[i]];
    }

    if (isLogin) {
      final hasNotifications = postLikesCache.isNotEmpty || followersCache.isNotEmpty;
      return hasNotifications;
    }

    await CacheHelper().initializeCache(
      likesPostCache: postLikesCache,
      followersCache: followersCache,
    );

    return true;

  }

  Future<bool> _notifyNewNotification() async {

    final currentLikes = await notificationsGetter.getUserPostsWithRecentLikes();
    final currentFollowers = await notificationsGetter.getUserFollowers();

    final caches = await CacheHelper().getNotificationCache();

    final storedLikes = caches[CacheNames.postLikesCache];
    final storedFollowers = caches[CacheNames.followersCache];

    bool shouldNotify = false;

    final titles = currentLikes['title']!;
    final likeCounts = currentLikes['like_count']!;
    final likedAt = currentLikes['liked_at']!;

    for (int i = 0; i < titles.length; i++) {
      
      final title = titles[i];
      final newCount = likeCounts[i];

      final storedLikeEntry = storedLikes[title];
      final oldCount = (storedLikeEntry is List && storedLikeEntry.isNotEmpty)
        ? (storedLikeEntry[0] as num?)?.toInt() ?? 0 : 0; 

      if (newCount != oldCount) {
        shouldNotify = true;
        storedLikes[title] = [newCount, likedAt[i]];
        break;
      }

    }

    final newFollowers = currentFollowers['followers']!;
    final followedAt = currentFollowers['followed_at']!;

    final previousFollowerKeys = storedFollowers.keys.toSet();
    final currentFollowerKeys = newFollowers.toSet();

    final detectedNewFollowers = currentFollowerKeys.difference(previousFollowerKeys);

    if (detectedNewFollowers.isNotEmpty) {

      shouldNotify = true;

      for (int i = 0; i < newFollowers.length; i++) {

        final follower = newFollowers[i];

        if (detectedNewFollowers.contains(follower)) {
          storedFollowers[follower] = [followedAt[i]];
        }

      }

    }

    return shouldNotify;

  }

}