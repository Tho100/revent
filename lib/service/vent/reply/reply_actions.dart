import 'package:revent/helper/format/format_date.dart';
import 'package:revent/shared/api/api_client.dart';
import 'package:revent/shared/api/api_path.dart';
import 'package:revent/shared/provider_mixins.dart';
import 'package:revent/service/general/id_service.dart';
import 'package:revent/shared/provider/vent/replies_provider.dart';

class ReplyActionsService with 
  RepliesProviderService, 
  UserProfileProviderService, 
  VentProviderService {

  String replyText;
  String repliedBy;
  String commentText;
  String commentedBy;

  ReplyActionsService({
    required this.replyText, 
    required this.repliedBy,
    required this.commentText,
    required this.commentedBy
  });

  Future<int> _getCommentId() async {

    return await IdService.getCommentId(
      postId: activeVentProvider.ventData.postId,
      username: commentedBy, 
      commentText: commentText
    );

  }

  Future<int> _getReplyId(int commentId) async {

    return await IdService.getReplyId(
      commentId: commentId, 
      username: repliedBy, 
      replyText: replyText
    );

  }

  int _getReplyIndex() {
    return repliesProvider.replies.indexWhere(
      (reply) => reply.repliedBy == repliedBy && reply.reply == replyText
    );
  }

  Future<Map<String, dynamic>> send() async {

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

  Future<Map<String, dynamic>> toggleLike() async {

    final commentId = await _getCommentId();

    final replyId = _getReplyId(commentId);

    final response = await ApiClient.post(ApiPath.likeReply, {
      'reply_id': replyId,
      'liked_by': userProvider.user.username
    });

    if (response.statusCode == 200) {

      final index = _getReplyIndex();

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

    final replyId = await _getReplyId(commentId);

    final response = await ApiClient.deleteById(ApiPath.deleteReply, replyId);

    if (response.statusCode == 204) {
      _removeComment();
    }

    return {
      'status_code': response.statusCode
    };

  }

  void _removeComment() {

    final index = _getReplyIndex();

    if (index != -1) {
      repliesProvider.deleteReply(index);
    }

  }

}