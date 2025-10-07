import 'package:revent/helper/extract_data.dart';
import 'package:revent/helper/format_date.dart';
import 'package:revent/service/query/general/base_query_service.dart';
import 'package:revent/shared/api/api_client.dart';
import 'package:revent/shared/api/api_path.dart';
import 'package:revent/shared/provider_mixins.dart';

class ActivitiesGetter extends BaseQueryService with UserProfileProviderService {

  final formatDate = FormatDate();

  Future<Map<String, List<String>>> getUserFollowers() async {

    final response = await ApiClient.post(ApiPath.activityFollowersGetter, {
      'current_user': userProvider.user.username
    });

    final extractedData = ExtractData(data: response.body!['followers']);

    final followers = extractedData.extractColumn<String>('follower');

    final followedAt = formatDate.formatToPostDate2(
      extractedData.extractColumn<String>('followed_at')
    );

    return {
      'followers': followers,
      'followed_at': followedAt
    };

  }

  /// Retrieves posts created by the current user that received specific 
  /// number of likes (1, 2, 5, 10, 50, 100) within the past 14 days.
// TODO: Sync function naming with backend
  Future<Map<String, List<dynamic>>> getUserPostsWithRecentLikes() async {

    final response = await ApiClient.post(ApiPath.activityRecentPostsLikesGetter, {
      'current_user': userProvider.user.username
    });

    final extractedData = ExtractData(data: response.body!['posts']);

    final titles = extractedData.extractColumn<String>('title');
    final likeCount = extractedData.extractColumn<int>('like_count');

    final likedAt = formatDate.formatToPostDate2(
      extractedData.extractColumn<String>('liked_at')
    );

    return {
      'title': titles,
      'like_count': likeCount,
      'liked_at': likedAt
    };

  }

  Future<Map<String, List<dynamic>>> getUserPostsAllTimeLikes() async {

    final response = await ApiClient.post(ApiPath.activityAllTimePostsLikesGetter, {
      'current_user': userProvider.user.username
    });

    final extractedData = ExtractData(data: response.body!['posts']);

    final titles = extractedData.extractColumn<String>('title');
    final likeCount = extractedData.extractColumn<int>('like_count');

    final likedAt = formatDate.formatToPostDate2(
      extractedData.extractColumn<String>('liked_at')
    );

    return {
      'title': titles,
      'like_count': likeCount,
      'liked_at': likedAt
    };

  }

}