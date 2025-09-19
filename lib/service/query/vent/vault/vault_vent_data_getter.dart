import 'package:revent/global/table_names.dart';
import 'package:revent/service/query/general/base_query_service.dart';
import 'package:revent/helper/extract_data.dart';
import 'package:revent/helper/format_date.dart';

class VaultVentDataGetter extends BaseQueryService {

  Future<Map<String, List<dynamic>>> getMetadata({required String username}) async {

    const query = 
    '''
      SELECT 
        post_id, title, created_at, tags 
      FROM ${TableNames.vaultVentInfo} 
      WHERE creator = :username ORDER BY created_at DESC
    ''';

    final param = {'username': username};

    final results = await executeQuery(query, param);

    final extractData = ExtractData(rowsData: results);
    
    final postId = extractData.extractIntColumn('post_id');
    final title = extractData.extractStringColumn('title');
    final tags = extractData.extractStringColumn('tags');

    final postTimestamp = FormatDate().formatToPostDate(
      data: extractData, columnName: 'created_at'
    );

    return {
      'post_id': postId,
      'title': title,
      'tags': tags,
      'post_timestamp': postTimestamp
    };

  }

  Future<String> getBodyText({required int postId}) async {

    const query = 
      'SELECT body_text FROM ${TableNames.vaultVentInfo} WHERE post_id = :post_id';
      
    final params = {'post_id': postId};

    final results = await executeQuery(query, params); 

    final extractedData = ExtractData(rowsData: results); 

    return extractedData.extractStringColumn('body_text')[0];

  }

}