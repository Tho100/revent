import 'package:revent/helper/extract_data.dart';
import 'package:revent/service/query/general/base_query_service.dart';

class CommentIdGetter extends BaseQueryService {

  final int postId;

  CommentIdGetter({required this.postId});

  Future<int> getCommentId({
    required String username, 
    required String commentText
  }) async {

    const getCommentIdQuery = 
      'SELECT comment_id FROM vent_comments_info WHERE post_id = :post_id AND commented_by = :commented_by AND comment = :comment';

    final commentParams = {
      'post_id': postId,
      'commented_by': username,
      'comment': commentText
    };

    final commentIdResults = await executeQuery(getCommentIdQuery, commentParams);

    return ExtractData(rowsData: commentIdResults).extractIntColumn('comment_id')[0];

  }

  Future<List<int>> getAllCommentsId() async {

    const getPostIdQuery = 'SELECT comment_id FROM vent_comments_info WHERE post_id = :post_id';

    final param = {'post_id': postId};

    final results = await executeQuery(getPostIdQuery, param);

    return ExtractData(rowsData: results).extractIntColumn('comment_id');


  }

}