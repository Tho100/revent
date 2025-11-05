import 'package:revent/helper/data/extract_data.dart';
import 'package:revent/helper/format/format_date.dart';
import 'package:revent/shared/api/api_client.dart';
import 'package:revent/shared/api/api_path.dart';
import 'package:revent/shared/provider_mixins.dart';

class ActivitiesService with UserProfileProviderService {

  final formatDate = FormatDate();

  Future<Map<String, List<String>>> getUserFollowers() async {

    final response = await ApiClient.get(ApiPath.activityFollowersGetter, userProvider.user.username);

    final extractedData = ExtractData(data: response.body!['followers']);

    final followers = extractedData.extractColumn<String>('follower');

    final followedAt = formatDate.formatToPostDate(
      extractedData.extractColumn<String>('followed_at')
    );

    return {
      'followers': followers,
      'followed_at': followedAt
    };

  }

  Future<Map<String, List<dynamic>>> getRecentLikeMilestones() async {

    final response = await ApiClient.get(ApiPath.activityRecentLikesGetter, userProvider.user.username);

    final extractedData = ExtractData(data: response.body!['posts']);

    final titles = extractedData.extractColumn<String>('title');
    final likeCount = extractedData.extractColumn<int>('like_count');

    final likedAt = formatDate.formatToPostDate(
      extractedData.extractColumn<String>('liked_at')
    );

    return {
      'title': titles,
      'like_count': likeCount,
      'liked_at': likedAt
    };

  }

  Future<Map<String, List<dynamic>>> getAllTimeLikeMilestones() async {

    final response = await ApiClient.get(ApiPath.activityAllTimeLikesGetter, userProvider.user.username);

    final extractedData = ExtractData(data: response.body!['posts']);

    final titles = extractedData.extractColumn<String>('title');
    final likeCount = extractedData.extractColumn<int>('like_count');

    final likedAt = formatDate.formatToPostDate(
      extractedData.extractColumn<String>('liked_at')
    );

    return {
      'title': titles,
      'like_count': likeCount,
      'liked_at': likedAt
    };

  }

}