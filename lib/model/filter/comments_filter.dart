import 'package:revent/helper/format_date.dart';
import 'package:revent/shared/provider_mixins.dart';

class CommentsFilter with CommentsProviderService {

  final _formatTimestamp = FormatDate();

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
      ..sort((a, b) => _formatTimestamp.parseFormattedTimestamp(a.commentTimestamp)
        .compareTo(_formatTimestamp.parseFormattedTimestamp(b.commentTimestamp)));

    commentsProvider.setComments(sortedComments);

  }

  void filterCommentToOldest() {

    final sortedComments = commentsProvider.comments
      .toList()
      ..sort((a, b) => _formatTimestamp.parseFormattedTimestamp(b.commentTimestamp)
        .compareTo(_formatTimestamp.parseFormattedTimestamp(a.commentTimestamp)));

    commentsProvider.setComments(sortedComments);

  }

}