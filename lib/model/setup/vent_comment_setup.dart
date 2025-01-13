import 'dart:typed_data';

import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/main.dart';
import 'package:revent/shared/provider/vent/vent_comment_provider.dart';
import 'package:revent/service/query/vent/comment/vent_comments_getter.dart';

class VentCommentSetup {

  Future<void> setup({
    required String title,
    required String creator
  }) async {

    final commentsInfo = await VentCommentsGetter(
      title: title, 
      creator: creator
    ).getComments();

    final commentedBy = commentsInfo['commented_by']! as List<String>;
    final comment = commentsInfo['comment']! as List<String>;
    final commentTimestamp = commentsInfo['comment_timestamp']! as List<String>;

    final totalLikes = commentsInfo['total_likes']! as List<int>;

    final isLiked = commentsInfo['is_liked']! as List<bool>;
    final isLikedByCreator = commentsInfo['is_liked_by_creator']! as List<bool>;

    final pfpData = commentsInfo['profile_picture']! as List<Uint8List>;

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

    getIt.ventCommentProvider.setComments(comments);

  }

}