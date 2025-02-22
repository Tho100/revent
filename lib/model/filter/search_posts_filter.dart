import 'package:revent/helper/format_date.dart';
import 'package:revent/helper/providers_service.dart';
import 'package:revent/shared/provider/search/search_posts_provider.dart';

class SearchPostsFilter with SearchProviderService {

  final formatTimestamp = FormatDate();

  void filterPostsToBest() {

    final sortedVents = searchPostsProvider.vents
      .toList()
      ..sort((a, b) => a.totalLikes.compareTo(b.totalLikes));

    searchPostsProvider.setVents(sortedVents);

  }

  void filterPostsToLatest() {

    final sortedVents = searchPostsProvider.vents
      .toList()
      ..sort((a, b) => formatTimestamp.parseFormattedTimestamp(b.postTimestamp)
        .compareTo(formatTimestamp.parseFormattedTimestamp(a.postTimestamp)));

    searchPostsProvider.setVents(sortedVents);

  }

  void filterPostsToOldest() {

    final sortedVents = searchPostsProvider.vents
      .toList()
      ..sort((a, b) => formatTimestamp.parseFormattedTimestamp(a.postTimestamp)
        .compareTo(formatTimestamp.parseFormattedTimestamp(b.postTimestamp)));

    searchPostsProvider.setVents(sortedVents);

  }

  void filterToControversial() {

    final allPosts = searchPostsProvider.vents;

    final controversialPosts = allPosts.where(
      (post) => post.totalComments >= post.totalLikes
    ).toList();

    final nonControversialPosts = allPosts.where(
      (post) => post.totalComments < post.totalLikes
    ).toList();

    final sortedVents = [...nonControversialPosts, ...controversialPosts];

    searchPostsProvider.setVents(sortedVents);

  }

  void filterPostsByTimestamp(String timestamp) {

    final now = DateTime.now();

    DateTime threshold;

    switch (timestamp) {
      case 'Past year':
        threshold = now.subtract(const Duration(days: 365));
        break;
      case 'Past month':
        threshold = now.subtract(const Duration(days: 30));
        break;
      case 'Past week':
        threshold = now.subtract(const Duration(days: 7));
        break;
      case 'Today':
        threshold = DateTime(now.year, now.month, now.day);
        break;
      case 'All time':
      default:
        searchPostsProvider.setVents(searchPostsProvider.vents);
        return;
    }

    final allPosts = searchPostsProvider.vents;

    final recentPosts = <SearchVents>[];
    final olderPosts = <SearchVents>[];

    for (var post in allPosts) {

      final postDate = formatTimestamp.convertRelativeTimestampToDateTime(post.postTimestamp);

      postDate.isAfter(threshold) 
        ? recentPosts.add(post)
        : olderPosts.add(post);

    }

    final sortedVents = [...olderPosts, ...recentPosts];

    searchPostsProvider.setVents(sortedVents);
    
  }

}