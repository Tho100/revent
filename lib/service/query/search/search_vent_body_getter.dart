import 'package:revent/service/query/general/base_query_service.dart';
// TODO: Rename this file
class SearchVentBodyGetter extends BaseQueryService {

  final int postId;

  SearchVentBodyGetter({required this.postId});

  Future<String> getBodyText() async {

    const query = 'SELECT body_text FROM vent_info WHERE post_id = :post_id';

    final param = {'post_id': postId};

    final results = await executeQuery(query, param);

    return results.rows.last.assoc()['body_text']!;
    
  }

}