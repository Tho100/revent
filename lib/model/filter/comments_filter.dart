import 'package:revent/helper/format_date.dart';
import 'package:revent/helper/providers_service.dart';

class CommentsFilter with CommentsProviderService {

  final formatTimestamp = FormatDate();

  void filterCommentToBest() {

    final sortedComments = commentsProvider.comments
      .toList()
      ..sort((a, b) => b.totalLikes.compareTo(a.totalLikes));

    sortedComments.sort((a, b) {
      if (a.isPinned && !b.isPinned) return -1;
      if (!a.isPinned && b.isPinned) return 1;
      return 0;
    });

    commentsProvider.setComments(sortedComments);

  }

  void filterCommentToLatest() {

    final sortedComments = commentsProvider.comments
      .toList()
      ..sort((a, b) => formatTimestamp.parseFormattedTimestamp(a.commentTimestamp)
        .compareTo(formatTimestamp.parseFormattedTimestamp(b.commentTimestamp)));

    commentsProvider.setComments(sortedComments);

  }

  void filterCommentToOldest() {

    final sortedComments = commentsProvider.comments
      .toList()
      ..sort((a, b) => formatTimestamp.parseFormattedTimestamp(b.commentTimestamp)
        .compareTo(formatTimestamp.parseFormattedTimestamp(a.commentTimestamp)));

    commentsProvider.setComments(sortedComments);

  }

}