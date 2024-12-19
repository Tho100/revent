import 'package:revent/service/query/general/base_query_service.dart';

class SearchDataGetter extends BaseQueryService {

  final String title;
  final String creator;

  SearchDataGetter({
    required this.title, 
    required this.creator
  });

  Future<String> getBodyText() async {

    const query = 'SELECT body_text FROM vent_info WHERE title = :title AND creator = :creator';

    final params = {
      'title': title,
      'creator': creator
    };

    final results = await executeQuery(query, params);

    return results.rows.last.assoc()['body_text']!;
    
  }

}