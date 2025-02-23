import 'package:revent/helper/format_date.dart';
import 'package:revent/helper/providers_service.dart';

class SearchPostsFilter with SearchProviderService {

  final formatTimestamp = FormatDate();

  void filterPostsToBest() {

    final sortedVents = searchPostsProvider.vents
      .toList()
      ..sort((a, b) => a.totalLikes.compareTo(b.totalLikes));

    searchPostsProvider.setFilteredVents(sortedVents);

  }

  void filterPostsToLatest() {

    final sortedVents = searchPostsProvider.vents
      .toList()
      ..sort((a, b) => formatTimestamp.parseFormattedTimestamp(b.postTimestamp)
        .compareTo(formatTimestamp.parseFormattedTimestamp(a.postTimestamp)));

    searchPostsProvider.setFilteredVents(sortedVents);

  }

  void filterPostsToOldest() {

    final sortedVents = searchPostsProvider.vents
      .toList()
      ..sort((a, b) => formatTimestamp.parseFormattedTimestamp(a.postTimestamp)
        .compareTo(formatTimestamp.parseFormattedTimestamp(b.postTimestamp)));

    searchPostsProvider.setFilteredVents(sortedVents);

  }

  void filterToControversial() {

    final sortedVents = searchPostsProvider.vents
      .toList()
      ..sort((a, b) => a.totalComments.compareTo(b.totalComments));

    searchPostsProvider.setFilteredVents(sortedVents);

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
        searchPostsProvider.setFilteredVents(searchPostsProvider.vents);
        return;
    }

    final filteredPosts = searchPostsProvider.vents.where((post) {
      final postDate = formatTimestamp.convertRelativeTimestampToDateTime(post.postTimestamp);
      return postDate.isAfter(threshold);
    }).toList();

    searchPostsProvider.setFilteredVents(filteredPosts);

  }

}