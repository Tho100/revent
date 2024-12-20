import 'package:revent/helper/format_date.dart';
import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/main.dart';

class CommentsFilter {

  final ventCommentProvider = getIt.ventCommentProvider;

  final formatTimestamp = FormatDate();

  void filterCommentToBest() {

    final sortedComments = ventCommentProvider.ventComments
      .toList()
      ..sort((a, b) => a.totalLikes.compareTo(b.totalLikes));

    ventCommentProvider.setComments(sortedComments);

  }

  void filterCommentToLatest() {

    final sortedComments = ventCommentProvider.ventComments
      .toList()
      ..sort((a, b) => formatTimestamp.parseFormattedTimestamp(b.commentTimestamp)
        .compareTo(formatTimestamp.parseFormattedTimestamp(a.commentTimestamp)));

    ventCommentProvider.setComments(sortedComments);

  }

  void filterCommentToOldest() {

    final sortedComments = ventCommentProvider.ventComments
      .toList()
      ..sort((a, b) => formatTimestamp.parseFormattedTimestamp(a.commentTimestamp)
        .compareTo(formatTimestamp.parseFormattedTimestamp(b.commentTimestamp)));

    ventCommentProvider.setComments(sortedComments);

  }

}