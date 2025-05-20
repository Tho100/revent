import 'package:revent/service/query/general/base_query_service.dart';
import 'package:revent/service/query/general/post_id_getter.dart';

class SearchVentBodyGetter extends BaseQueryService {

  final String title;
  final String creator;

  SearchVentBodyGetter({
    required this.title, 
    required this.creator
  });

  Future<String> getBodyText() async {

    final postId = await PostIdGetter(title: title, creator: creator).getPostId();

    const query = 'SELECT body_text FROM vent_info WHERE post_id = post_id';

    final param = {'post_id': postId};

    final results = await executeQuery(query, param);

    return results.rows.last.assoc()['body_text']!;
    
  }

}