import 'package:get_it/get_it.dart';
import 'package:revent/provider/vent_comment_provider.dart';
import 'package:revent/vent_query/comment/vent_comments_getter.dart';

class VentCommentSetup {

  final ventCommentProvider = GetIt.instance<VentCommentProvider>();

  Future<void> setup({
    required String title,
    required String creator
  }) async {

    final commentsGetter = await VentCommentsGetter(
      title: title, 
      creator: creator
    ).getComments();

    // TODO: Add type casting
    final commentedBy = commentsGetter['commented_by']!;
    final comment = commentsGetter['comment']!;
    final commentTimestamp = commentsGetter['comment_timestamp']!;

    final totalLikes = commentsGetter['total_likes']!;
    final isLiked = commentsGetter['is_liked']!;

    final pfpData = commentsGetter['profile_picture']!;

    final comments = List.generate(commentedBy.length, (index) {
      return VentComment(
        commentedBy: commentedBy[index],
        comment: comment[index],
        commentTimestamp: commentTimestamp[index],
        totalLikes: totalLikes[index],
        isCommentLiked: isLiked[index],
        pfpData: pfpData[index]
      );
    });

    ventCommentProvider.setComments(comments);

  }

}