// TODO: rename file to id_getter, remove unused id-getter files

import 'package:revent/shared/api/api_client.dart';
import 'package:revent/shared/api/api_path.dart';

class IdGetter {

  Future<int> getPostId({
    required String title, 
    required String creator
  }) async {

    final response = await ApiClient.post(ApiPath.postIdGetter, {
      'title': title,
      'creator': creator
    });

    return response.body!['post_id'] as int;

  }

  Future<int> getCommentId({
    required int postId,
    required String username, 
    required String commentText
  }) async {

    final response = await ApiClient.post(ApiPath.commentIdGetter, {
      'post_id': postId,
      'commented_by': username,
      'comment': commentText
    });

    return response.body!['comment_id'] as int;

  }

  Future<int> getReplyId({
    required int commentId,
    required String username, 
    required String replyText
  }) async {

    final response = await ApiClient.post(ApiPath.replyIdGetter, {
      'comment_id': commentId,
      'replied_by': username,
      'reply': replyText
    });

    return response.body!['reply_id'] as int;

  }

}