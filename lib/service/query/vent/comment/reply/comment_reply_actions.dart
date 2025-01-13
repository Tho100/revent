import 'package:revent/helper/format_date.dart';
import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/main.dart';
import 'package:revent/service/query/general/base_query_service.dart';
import 'package:revent/service/query/general/comment_id_getter.dart';
import 'package:revent/service/query/general/post_id_getter.dart';
import 'package:revent/shared/provider/vent/comment_replies_provider.dart';

class ReplyActions extends BaseQueryService {

  final String title;
  final String creator;

  ReplyActions({
    required this.creator,
    required this.title
  });

  Future<void> sendReply({
    required String reply, 
    required String commentText,
    required String commentedBy
  }) async {

    final postId = await PostIdGetter(title: title, creator: creator).getPostId();

    final commentId = await CommentIdGetter(postId: postId).getCommentId(
      username: commentedBy, commentText: commentText
    );

    const query = 
      'INSERT INTO comment_replies_info (reply, comment_id, replied_by, total_likes) VALUES (:reply, :comment_id, :replied_by, :total_likes)';

    final params = {
      'reply': reply,
      'comment_id': commentId,
      'replied_by': getIt.userProvider.user.username,
      'total_likes': 0
    };

    await executeQuery(query, params).then(
      (_) => _addComment(reply: reply)
    );
    
  }
  
  void _addComment({required String reply}) {

    final now = DateTime.now();
    final formattedTimestamp = FormatDate().formatPostTimestamp(now);

    final newReply = CommentRepliesData(
      reply: reply,
      repliedBy: getIt.userProvider.user.username, 
      replyTimestamp: formattedTimestamp,
      pfpData: getIt.profileProvider.profile.profilePicture
    );

    getIt.commentRepliesProvider.addReply(newReply);

  }

}