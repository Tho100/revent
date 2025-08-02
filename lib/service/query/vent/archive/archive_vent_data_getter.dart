import 'package:revent/global/table_names.dart';
import 'package:revent/service/query/general/base_query_service.dart';
import 'package:revent/helper/extract_data.dart';
import 'package:revent/helper/format_date.dart';

class ArchiveVentDataGetter extends BaseQueryService {

  Future<Map<String, List<dynamic>>> getMetadata({required String username}) async {

    const query = '''
      SELECT 
        title, created_at, tags 
      FROM ${TableNames.archiveVentInfo} 
      WHERE creator = :username ORDER BY created_at DESC
    ''';

    final param = {'username': username};

    final results = await executeQuery(query, param);

    final extractData = ExtractData(rowsData: results);
    
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
      'SELECT body_text FROM ${TableNames.archiveVentInfo} WHERE title = :title AND creator = :creator';
      
    final params = {
      'title': title,
      'creator': creator
    };

    final results = await executeQuery(query, params); 

    final extractedData = ExtractData(rowsData: results); 

    return extractedData.extractStringColumn('body_text')[0];

  }

}