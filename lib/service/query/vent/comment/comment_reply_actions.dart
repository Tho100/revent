import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/main.dart';
import 'package:revent/service/query/general/base_query_service.dart';
import 'package:revent/service/query/general/comment_id_getter.dart';
import 'package:revent/service/query/general/post_id_getter.dart';

class CommentReplyActions extends BaseQueryService {

  final String title;
  final String creator;

  CommentReplyActions({
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
      'INSERT INTO comment_replies_info (reply, comment_id, replied_by) VALUES (:reply, :comment_id, :replied_by)';

    final params = {
      'reply': reply,
      'comment_id': commentId,
      'replied_by': getIt.userProvider.user.username
    };

    await executeQuery(query, params);
    
  }
  
}