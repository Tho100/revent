import 'package:revent/helper/format_date.dart';
import 'package:revent/helper/providers_service.dart';

class CommentsFilter with CommentsProviderService {

  final formatTimestamp = FormatDate();

  void filterCommentToBest() {

    final sortedComments = commentsProvider.comments
      .toList()
      ..sort((a, b) => a.totalLikes.compareTo(b.totalLikes));

    commentsProvider.setComments(sortedComments);

  }

  void filterCommentToLatest() {

    final sortedComments = commentsProvider.comments
      .toList()
      ..sort((a, b) => formatTimestamp.parseFormattedTimestamp(b.commentTimestamp)
        .compareTo(formatTimestamp.parseFormattedTimestamp(a.commentTimestamp)));

    commentsProvider.setComments(sortedComments);

  }

  void filterCommentToOldest() {

    final sortedComments = commentsProvider.comments
      .toList()
      ..sort((a, b) => formatTimestamp.parseFormattedTimestamp(a.commentTimestamp)
        .compareTo(formatTimestamp.parseFormattedTimestamp(b.commentTimestamp)));

    commentsProvider.setComments(sortedComments);

  }

}