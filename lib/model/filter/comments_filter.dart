import 'package:revent/helper/format/format_date.dart';
import 'package:revent/shared/provider_mixins.dart';

class CommentsFilter with CommentsProviderService {

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
      ..sort((a, b) => FormatDate.parseFormattedTimestamp(a.commentTimestamp)
        .compareTo(FormatDate.parseFormattedTimestamp(b.commentTimestamp)));

    commentsProvider.setComments(sortedComments);

  }

  void filterCommentToOldest() {

    final sortedComments = commentsProvider.comments
      .toList()
      ..sort((a, b) => FormatDate.parseFormattedTimestamp(b.commentTimestamp)
        .compareTo(FormatDate.parseFormattedTimestamp(a.commentTimestamp)));

    commentsProvider.setComments(sortedComments);

  }

}