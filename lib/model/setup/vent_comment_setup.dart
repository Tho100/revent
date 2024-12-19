import 'dart:typed_data';

import 'package:get_it/get_it.dart';
import 'package:revent/shared/provider/vent/vent_comment_provider.dart';
import 'package:revent/service/query/vent_query/comment/vent_comments_getter.dart';

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

    final commentedBy = commentsGetter['commented_by']! as List<String>;
    final comment = commentsGetter['comment']! as List<String>;
    final commentTimestamp = commentsGetter['comment_timestamp']! as List<String>;

    final totalLikes = commentsGetter['total_likes']! as List<int>;

    final isLiked = commentsGetter['is_liked']! as List<bool>;
    final isLikedByCreator = commentsGetter['is_liked_by_creator']! as List<bool>;

    final pfpData = commentsGetter['profile_picture']! as List<Uint8List>;

    final comments = List.generate(commentedBy.length, (index) {
      return VentCommentData(
        commentedBy: commentedBy[index],
        comment: comment[index],
        commentTimestamp: commentTimestamp[index],
        totalLikes: totalLikes[index],
        isCommentLiked: isLiked[index],
        isCommentLikedByCreator: isLikedByCreator[index],
        pfpData: pfpData[index]
      );
    });

    ventCommentProvider.setComments(comments);

  }

}