import 'package:revent/global/table_names.dart';
import 'package:revent/helper/extract_data.dart';
import 'package:revent/service/query/general/base_query_service.dart';

class ReplyIdGetter extends BaseQueryService {

  final int commentId;

  ReplyIdGetter({required this.commentId});

  Future<int> getReplyId({
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

  Future<List<int>> getAllRepliesId() async {

    const getPostIdQuery = 'SELECT reply_id FROM ${TableNames.commentRepliesInfo} WHERE comment_id = :comment_id';

    final param = {'comment_id': commentId};

    final results = await executeQuery(getPostIdQuery, param);

    return ExtractData(rowsData: results).extractIntColumn('reply_id');


  }

}