import 'dart:typed_data';

import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/main.dart';
import 'package:revent/service/query/vent/comment/reply/replies_getter.dart';
import 'package:revent/shared/provider/vent/comment_replies_provider.dart';

class RepliesSetup {

  Future<void> setup({required int commentId}) async {

    // TODO: improve naming
    final commentsGetter = await RepliesGetter(commentId: commentId).getReplies();

    final commentedBy = commentsGetter['replied_by']! as List<String>;
    final comment = commentsGetter['reply']! as List<String>;
    final commentTimestamp = commentsGetter['reply_timestamp']! as List<String>;

    final totalLikes = commentsGetter['total_likes']! as List<int>;

    final isLiked = commentsGetter['is_liked']! as List<bool>;
    final isLikedByCreator = commentsGetter['is_liked_by_creator']! as List<bool>;

    final pfpData = commentsGetter['profile_picture']! as List<Uint8List>;

    final replies = List.generate(commentedBy.length, (index) {
      return CommentRepliesData(
        repliedBy: commentedBy[index],
        reply: comment[index],
        replyTimestamp: commentTimestamp[index],
        totalLikes: totalLikes[index],
        isReplyLiked: isLiked[index],
        isReplyLikedByCreator: isLikedByCreator[index],
        pfpData: pfpData[index]
      );
    });

    getIt.commentRepliesProvider.setReplies(replies);

  }

}