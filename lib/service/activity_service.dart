import 'package:revent/global/cache_names.dart';
import 'package:revent/helper/cache_helper.dart';
import 'package:revent/service/general/activities_service.dart';
import 'package:revent/shared/provider_mixins.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ActivityService with NavigationProviderService {

  final activitiesService = ActivitiesService();

  Future<void> initializeActivities({bool isLogin = false}) async {

    final prefs = await SharedPreferences.getInstance();

    if (isLogin) {

      await syncActivityCaches(isLogin: true);

    } else {

      final hasNewActivity = await _hasNewActivity();

      if (hasNewActivity) {
        await prefs.setBool(CacheNames.unreadCache, true);
      }

    }

    final showBadge = prefs.getBool(CacheNames.unreadCache) ?? false;

    navigationProvider.setActivityBadgeVisible(showBadge);

  }

  Future<void> syncActivityCaches({bool isLogin = false}) async {

    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(CacheNames.unreadCache, false);

    final latestLikesData = isLogin 
      ? await activitiesService.getAllTimeLikeMilestones()
      : await activitiesService.getRecentLikeMilestones();
      
    final latestFollowersData = await activitiesService.getUserFollowers();

    final postTitles = latestLikesData['title']!;
    final postLikeCounts = latestLikesData['like_count']!;
    final postLikedTimestamps = latestLikesData['liked_at']!;

    final followers = latestFollowersData['followers']!;
    final followedAt = latestFollowersData['followed_at']!;

    final oldCaches = await CacheHelper().getActivityCache();

    final cachedLikes = Map<String, List<dynamic>>.from(
      oldCaches[CacheNames.postLikesCache] ?? {}
    );

    final cachedFollowers = Map<String, List<dynamic>>.from(
      oldCaches[CacheNames.followersCache] ?? {}
    );

    for (int i = 0; i < postTitles.length; i++) {
      cachedLikes[postTitles[i]] = [postLikeCounts[i], postLikedTimestamps[i]];
    }

    for (int i = 0; i < followers.length; i++) {
      cachedFollowers[followers[i]] = [followedAt[i]];
    }

    await CacheHelper().initializeCache(
      likesPostCache: cachedLikes,
      followersCache: cachedFollowers
    );

    if (isLogin) {

      final hasActivities = cachedLikes.isNotEmpty || cachedFollowers.isNotEmpty;

      navigationProvider.setActivityBadgeVisible(hasActivities);
      
    }

  }

  Future<bool> _hasNewActivity() async {

    final latestLikesData = await activitiesService.getRecentLikeMilestones();
    final latestFollowersData = await activitiesService.getUserFollowers();

    final caches = await CacheHelper().getActivityCache();

    final cachedLikes = Map<String, List<dynamic>>.from(
      caches[CacheNames.postLikesCache] ?? {}
    );

    final cachedFollowers = Map<String, List<dynamic>>.from(
      caches[CacheNames.followersCache] ?? {}
    );

    bool shouldNotify = false;

    final postTitles = latestLikesData['title']!;
    final postLikeCounts = latestLikesData['like_count']!;
    final postLikedTimestamps = latestLikesData['liked_at']!;

    for (int i = 0; i < postTitles.length; i++) {
      
      final title = postTitles[i];
      final newCount = postLikeCounts[i];

      final storedLikeEntry = cachedLikes[title];

      final oldCount = _extractCachedLikeCount(storedLikeEntry);

      if (newCount != oldCount) {
        shouldNotify = true;
        cachedLikes[title] = [newCount, postLikedTimestamps[i]];
        break;
      }

    }

    final latestFollowersList = latestFollowersData['followers']!;
    final followerTimestamps = latestFollowersData['followed_at']!;

    final cachedFollowersKeys = cachedFollowers.keys.toSet();
    final latestFollowerKeys = latestFollowersList.toSet();

    final newlyAddedFollowers = latestFollowerKeys.difference(cachedFollowersKeys);

    if (newlyAddedFollowers.isNotEmpty) {

      shouldNotify = true;

      for (int i = 0; i < latestFollowersList.length; i++) {

        final follower = latestFollowersList[i];

        if (newlyAddedFollowers.contains(follower)) {
          cachedFollowers[follower] = [followerTimestamps[i]];
        }

      }

    }
      
    if (shouldNotify) {

      await CacheHelper().initializeCache(
        likesPostCache: cachedLikes,
        followersCache: cachedFollowers
      );

    }

    return shouldNotify;

  }

  int _extractCachedLikeCount(List<dynamic>? storedLikeEntry) {

    if (storedLikeEntry is List && storedLikeEntry.isNotEmpty) {
      return (storedLikeEntry[0] as num?)?.toInt() ?? 0;
    }

    return 0;

  }

}