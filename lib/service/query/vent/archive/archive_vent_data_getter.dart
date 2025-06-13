import 'package:revent/service/query/general/base_query_service.dart';
import 'package:revent/helper/extract_data.dart';
import 'package:revent/helper/format_date.dart';

class ArchiveVentDataGetter extends BaseQueryService {

  Future<Map<String, List<dynamic>>> getPosts({required String username}) async {

    const query = 'SELECT title, created_at, tags FROM archive_vent_info WHERE creator = :username';

    final param = {'username': username};

    final retrievedInfo = await executeQuery(query, param);

    final extractData = ExtractData(rowsData: retrievedInfo);
    
    final title = extractData.extractStringColumn('title');
    final tags = extractData.extractStringColumn('tags');

    final postTimestamp = FormatDate().formatToPostDate(
      data: extractData, columnName: 'created_at'
    );

    return {
      'title': title,
      'tags': tags,
      'post_timestamp': postTimestamp
    };

  }

  Future<String> getBodyText({
    required String title,
    required String creator
  }) async {

    const query = 
      'SELECT body_text FROM archive_vent_info WHERE title = :title AND creator = :creator';
      
    final params = {
      'title': title,
      'creator': creator
    };

    final results = await executeQuery(query, params); // TODO: use extrractdata

    return results.rows.last.assoc()['body_text']!;

  }

}