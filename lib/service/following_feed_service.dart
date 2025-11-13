import 'package:revent/shared/api/api_client.dart';
import 'package:revent/shared/api/api_path.dart';
import 'package:revent/shared/provider_mixins.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FollowingFeedService with 
  UserProfileProviderService, 
  NavigationProviderService {

  Future<void> initializeFollowingFeedInfo() async {
    
    if (profileProvider.profile.following == 0) {
      navigationProvider.setFollowingFeedBadgeVisible(false);
      return;
    }

    final prefs = await SharedPreferences.getInstance();

    final latestPostId = await _getLatestPostId();

    final info = await _loadFeedInfo();

    final lastPostId = info['last_post_id'];
    final hasSeen = info['has_seen'];

    final showBadge = (latestPostId != lastPostId) || !hasSeen;

    await prefs.setInt('last_post_id', latestPostId);

    if (latestPostId != lastPostId) {
      await prefs.setBool('has_seen', false);
    }

    navigationProvider.setFollowingFeedBadgeVisible(showBadge);

  }

  Future<void> setHasSeen() async {

    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('has_seen', true);

    navigationProvider.setFollowingFeedBadgeVisible(false);

  }

  Future<Map<String, dynamic>> _loadFeedInfo() async {
    
    final prefs = await SharedPreferences.getInstance();

    final lastPostId = prefs.getInt('last_post_id') ?? 0;
    final hasSeen = prefs.getBool('has_seen') ?? false;

    return {
      'last_post_id': lastPostId,
      'has_seen': hasSeen
    };
    
  }

  Future<int> _getLatestPostId() async {

    final response = await ApiClient.get(ApiPath.userFollowingLatestPostId, userProvider.user.username);

    return response.body!['post_id'] ?? 0;

  }

}