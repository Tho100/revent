import 'package:revent/helper/format_date.dart';
import 'package:revent/shared/api/api_client.dart';
import 'package:revent/shared/api/api_path.dart';
import 'package:revent/shared/provider_mixins.dart';
import 'package:revent/service/query/general/comment_id_getter.dart';
import 'package:revent/service/query/general/replies_id_getter.dart';
import 'package:revent/shared/provider/vent/replies_provider.dart';

class ReplyActions with RepliesProviderService, UserProfileProviderService {

  String replyText;
  String repliedBy;
  String commentText;
  String commentedBy;

  ReplyActions({
    required this.replyText, 
    required this.repliedBy,
    required this.commentText,
    required this.commentedBy
  });

  Future<int> _getCommentId() async {

    return await CommentIdGetter().getCommentId(
      username: commentedBy, commentText: commentText
    );

  }

  Future<Map<String, dynamic>> sendReply() async {

    final commentId = await _getCommentId();

    final response = await ApiClient.post(ApiPath.createReply, {
      'reply': replyText,
      'replied_by': repliedBy,
      'comment_id': commentId
    });

    if (response.statusCode == 201) {
      _addReply();
    }

    return {
      'status_code': response.statusCode
    };

  }

  void _addReply() {

    final now = DateTime.now();
    final formattedTimestamp = FormatDate().formatPostTimestamp(now);

    final newReply = ReplyData(
      reply: replyText,
      repliedBy: repliedBy, 
      replyTimestamp: formattedTimestamp,
      pfpData: profileProvider.profile.profilePicture
    );

    repliesProvider.addReply(newReply);

  }

  Future<Map<String, dynamic>> toggleLikeReply() async {

    final commentId = await _getCommentId();

    final replyId = await ReplyIdGetter(
      commentId: commentId
    ).getReplyId(username: repliedBy, replyText: replyText);

    final response = await ApiClient.post(ApiPath.likeReply, {
      'reply_id': replyId,
      'liked_by': userProvider.user.username
    });

    if (response.statusCode == 200) {
// TODO: simplify by creating separated function
      final index = repliesProvider.replies.indexWhere(
        (reply) => reply.repliedBy == repliedBy && reply.reply == replyText
      );

      final isLiked = repliesProvider.replies[index].isReplyLiked;

      _updateCommentLikedValue(index, !isLiked);

    }

    return {
      'status_code': response.statusCode
    };

  }

  void _updateCommentLikedValue(int index, bool doLike) {

    if (index != -1) {
      repliesProvider.likeReply(index, doLike);
    }

  }

  Future<Map<String, dynamic>> delete() async {

    final commentId = await _getCommentId();

    final replyId = await ReplyIdGetter(
      commentId: commentId
    ).getReplyId(username: repliedBy, replyText: replyText);

    final response = await ApiClient.deleteById(ApiPath.deleteReply, replyId);

    if (response.statusCode == 204) {
      _removeComment();
    }

    return {
      'status_code': response.statusCode
    };

  }

  void _removeComment() {

    final index = repliesProvider.replies.indexWhere(
      (reply) => reply.repliedBy == repliedBy && reply.reply == replyText
    );

    if (index != -1) {
      repliesProvider.deleteReply(index);
    }

  }

}