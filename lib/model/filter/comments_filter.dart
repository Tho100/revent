import 'package:get_it/get_it.dart';
import 'package:revent/helper/format_date.dart';
import 'package:revent/provider/vent/vent_comment_provider.dart';

class CommentsFilter {

  final ventCommentProvider = GetIt.instance<VentCommentProvider>();

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