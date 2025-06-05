import 'dart:convert';

import 'package:revent/helper/providers_service.dart';
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

    final titles = currentLikes['title']!;
    final likeCounts = currentLikes['like_count']!;

    final newCache = <String, int>{};
    
    for (int i = 0; i < titles.length; i++) {
      newCache[titles[i]] = likeCounts[i];
    }

    await prefs.setString('post_like_cache', jsonEncode(newCache)).then(
      (_) => navigationProvider.setBadgeVisible(false)
    );

  }

  Future<bool> _notifyNewNotification() async {

    final currentLikes = await VentPostNotificationGetter().getPostLikes();

    final prefs = await SharedPreferences.getInstance();

    final storedLikesJson = prefs.getString('post_like_cache') ?? '{}';
    final storedLikes = jsonDecode(storedLikesJson);

    bool shouldNotify = false;

    final titles = currentLikes['title']!;
    final likeCounts = currentLikes['like_count']!;

    for (int i = 0; i < titles.length; i++) {

      final title = titles[i];
      final newCount = likeCounts[i];

      final oldCount = storedLikes[title]?.toInt() ?? 0;

      if (newCount != oldCount) {
        shouldNotify = true;
        break;
      }

    }

    print(storedLikes);

    return shouldNotify;

  }

}