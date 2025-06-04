import 'dart:convert';

import 'package:revent/service/query/notification/post_notification_getter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {

  Future<bool> notifyNewNotification() async {

    final currentLikes = await VentPostNotificationGetter().getPostLikes();

    final prefs = await SharedPreferences.getInstance();

    final storedLikesJson = prefs.getString('post_like_cache') ?? '{}';
    final storedLikes = jsonDecode(storedLikesJson);

    bool shouldNotify = false;

    final postIds = currentLikes['post_id']!;
    final likeCounts = currentLikes['like_count']!;

    for (int i = 0; i < postIds.length; i++) {
      final postId = postIds[i].toString();
      final newCount = likeCounts[i];

      final oldCount = storedLikes[postId]?.toInt() ?? 0;

      if (newCount != oldCount) {
        shouldNotify = true;
        break;
      }
    }

    return shouldNotify;

  }

}