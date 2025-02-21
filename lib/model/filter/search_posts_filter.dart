import 'package:revent/helper/format_date.dart';
import 'package:revent/helper/providers_service.dart';

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

}