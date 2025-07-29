import 'package:revent/helper/extract_data.dart';
import 'package:revent/helper/format_date.dart';
import 'package:revent/service/query/general/base_query_service.dart';
import 'package:revent/shared/provider_mixins.dart';

class NotificationsGetter extends BaseQueryService with UserProfileProviderService {

  final formatDate = FormatDate();

  Future<Map<String, List<String>>> getUserFollowers() async {

    const query = 'SELECT follower, followed_at FROM user_follows_info WHERE following = :username';

    final param = {'username': userProvider.user.username};

    final results = await executeQuery(query, param);

    final extractedData = ExtractData(rowsData: results);

    final followers = extractedData.extractStringColumn('follower');

    final followedAt = formatDate.formatToPostDate(
      data: extractedData, columnName: 'followed_at'
    );

    return {
      'followers': followers,
      'followed_at': followedAt
    };

  }

  /// Retrieves posts created by the current user that received specific 
  /// number of likes (1, 2, 5, 10, 50, 100) within the past 14 days.

  Future<Map<String, List<dynamic>>> getUserPostsWithRecentLikes() async {

    const query = 
    '''
      SELECT 
        vi.title, 
        vi.creator, 
        lvi.liked_at, 
        COUNT(lvi.post_id) AS like_count
      FROM vent_info vi
      INNER JOIN liked_vent_info lvi ON vi.post_id = lvi.post_id 
      WHERE vi.creator = :creator
        AND vi.created_at >= NOW() - INTERVAL 14 DAY
      GROUP BY vi.post_id 
      HAVING like_count IN (1, 2, 5, 10, 50, 100);
    ''';

    final param = {'creator': userProvider.user.username};

    final results = await executeQuery(query, param);

    final extractedData = ExtractData(rowsData: results);

    final titles = extractedData.extractStringColumn('title');
    final likeCount = extractedData.extractIntColumn('like_count');

    final likedAt = formatDate.formatToPostDate(
      data: extractedData, columnName: 'liked_at'
    );

    return {
      'title': titles,
      'like_count': likeCount,
      'liked_at': likedAt
    };

  }

  Future<Map<String, List<dynamic>>> getUserPostsAllTimeLikes() async {

    const query = 
    '''
      SELECT 
        vi.title, 
        vi.creator, 
        lvi.liked_at, 
        COUNT(lvi.post_id) AS like_count
      FROM vent_info vi
      INNER JOIN liked_vent_info lvi ON vi.post_id = lvi.post_id 
      WHERE vi.creator = :creator
      GROUP BY vi.post_id 
      HAVING like_count IN (1, 2, 5, 10, 50, 100);
    ''';

    final param = {'creator': userProvider.user.username};

    final results = await executeQuery(query, param);

    final extractedData = ExtractData(rowsData: results);

    final titles = extractedData.extractStringColumn('title');
    final likeCount = extractedData.extractIntColumn('like_count');

    final likedAt = formatDate.formatToPostDate(
      data: extractedData, columnName: 'liked_at'
    );

    return {
      'title': titles,
      'like_count': likeCount,
      'liked_at': likedAt
    };

  }

}