import 'dart:convert';

import 'package:revent/helper/extract_data.dart';
import 'package:revent/helper/format_date.dart';
import 'package:revent/helper/providers_service.dart';
import 'package:revent/service/query/general/base_query_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VentPostNotificationGetter extends BaseQueryService with UserProfileProviderService {

  final formatPostTimestamp = FormatDate();

  Future<bool> notifyNewNotification() async {

    final currentLikes = await getPostLikes();

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

  Future<Map<String, List<dynamic>>> getPostLikes() async {

    const query = 
    '''
      SELECT 
        vi.post_id,
        vi.title, 
        vi.creator, 
        lvi.liked_at, 
        COUNT(lvi.post_id) AS like_count
      FROM vent_info vi
      INNER JOIN liked_vent_info lvi ON vi.post_id = lvi.post_id 
      WHERE vi.creator = :creator
      GROUP BY vi.post_id HAVING like_count = 1 
        OR like_count = 5 
        OR like_count >= 10;
    ''';

    final param = {'creator': userProvider.user.username};

    final results = await executeQuery(query, param);

    final extractedData = ExtractData(rowsData: results);

    final postIds = extractedData.extractIntColumn('post_id');
    final titles = extractedData.extractStringColumn('title');
    final likeCount = extractedData.extractIntColumn('like_count');

    final likedAt = extractedData
      .extractStringColumn('liked_at')
      .map((timestamp) => formatPostTimestamp.formatPostTimestamp(DateTime.parse(timestamp)))
      .toList();

    return {
      'post_id': postIds,
      'title': titles,
      'like_count': likeCount,
      'liked_at': likedAt
    };

  }

}