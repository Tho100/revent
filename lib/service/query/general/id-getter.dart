class IdGetter {

  Future<int> getPostId({
    required String title, 
    required String creator
  }) async {

    const getPostIdQuery = 'SELECT post_id FROM ${TableNames.ventInfo} WHERE title = :title AND creator = :creator';

    final postParams = {
      'title': title,
      'creator': creator
    };

    final results = await executeQuery(getPostIdQuery, postParams);

    return ExtractData(rowsData: results).extractIntColumn('post_id')[0];

  }

  Future<int> getCommentId({
    required int postId,
    required String username, 
    required String commentText
  }) async {

    const getCommentIdQuery = 
    '''
      SELECT comment_id FROM ${TableNames.commentsInfo} 
      WHERE post_id = :post_id 
        AND commented_by = :commented_by 
        AND comment = :comment
    ''';

    final commentParams = {
      'post_id': activeVentProvider.ventData.postId,
      'commented_by': username,
      'comment': commentText
    };

    final commentIdResults = await executeQuery(getCommentIdQuery, commentParams);

    return ExtractData(rowsData: commentIdResults).extractIntColumn('comment_id')[0];

  }

  Future<int> getReplyId({
    required int commentId,
    required String username, 
    required String replyText
  }) async {

    const getCommentIdQuery = 
    '''
      SELECT reply_id FROM ${TableNames.commentRepliesInfo} 
      WHERE comment_id = :comment_id 
        AND replied_by = :replied_by 
        AND reply = :reply
    ''';

    final commentParams = {
      'comment_id': commentId,
      'replied_by': username,
      'reply': replyText
    };

    final commentIdResults = await executeQuery(getCommentIdQuery, commentParams);

    return ExtractData(rowsData: commentIdResults).extractIntColumn('reply_id')[0];

  }

}