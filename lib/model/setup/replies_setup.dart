import 'dart:typed_data';

import 'package:revent/helper/providers_service.dart';
import 'package:revent/service/query/vent/comment/reply/replies_getter.dart';
import 'package:revent/shared/provider/vent/replies_provider.dart';

class RepliesSetup with RepliesProviderService {

  Future<void> setup({required int commentId}) async {

    final repliesInfo = await RepliesGetter(commentId: commentId).getReplies();

    final repliedBy = repliesInfo['replied_by']! as List<String>;
    final reply = repliesInfo['reply']! as List<String>;
    final replyTimestamp = repliesInfo['reply_timestamp']! as List<String>;

    final totalLikes = repliesInfo['total_likes']! as List<int>;

    final isLiked = repliesInfo['is_liked']! as List<bool>;
    final isLikedByCreator = repliesInfo['is_liked_by_creator']! as List<bool>;

    final pfpData = repliesInfo['profile_picture']! as List<Uint8List>;

    final replies = List.generate(repliedBy.length, (index) {
      return ReplyData(
        repliedBy: repliedBy[index],
        reply: reply[index],
        replyTimestamp: replyTimestamp[index],
        totalLikes: totalLikes[index],
        isReplyLiked: isLiked[index],
        isReplyLikedByCreator: isLikedByCreator[index],
        pfpData: pfpData[index]
      );
    });

    repliesProvider.setReplies(replies);

  }

}