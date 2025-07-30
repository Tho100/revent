import 'package:revent/global/table_names.dart';
import 'package:revent/helper/extract_data.dart';
import 'package:revent/service/query/general/base_query_service.dart';

class PostIdGetter extends BaseQueryService {

  final String? title;
  final String? creator;

  PostIdGetter({
    this.title,
    this.creator
  });

  Future<int> getPostId() async {

    const getPostIdQuery = 'SELECT post_id ${TableNames.ventInfo} WHERE title = :title AND creator = :creator';

    final postParams = {
      'title': title,
      'creator': creator
    };

    final results = await executeQuery(getPostIdQuery, postParams);

    return ExtractData(rowsData: results).extractIntColumn('post_id')[0];

  }

  Future<List<int>> getAllProfilePostsId() async {

    const getPostIdQuery = 'SELECT post_id ${TableNames.ventInfo} WHERE creator = :creator';

    final param = {'creator': creator};

    final results = await executeQuery(getPostIdQuery, param);

    return ExtractData(rowsData: results).extractIntColumn('post_id');

  }

}