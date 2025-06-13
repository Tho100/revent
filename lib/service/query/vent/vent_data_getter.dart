import 'package:revent/helper/extract_data.dart';
import 'package:revent/helper/format_date.dart';
import 'package:revent/service/query/general/base_query_service.dart';

class VentDataGetter extends BaseQueryService {

  final int postId;

  VentDataGetter({required this.postId});

  Future<String> getBodyText() async {

    const query = 'SELECT body_text FROM vent_info WHERE post_id = :post_id';

    final param = {'post_id': postId};

    final results = await executeQuery(query, param);

    return results.rows.last.assoc()['body_text']!;
    
  }

  Future<Map<String, dynamic>> getMetadata() async {

    const query = 
    '''
      SELECT tags, total_likes, created_at, marked_nsfw 
      FROM vent_info 
      WHERE post_id = :post_id
    ''';

    final param = {'post_id': postId};

    final results = await executeQuery(query, param);

    final extractedData = ExtractData(rowsData: results);

    final tags = extractedData.extractStringColumn('tags');
    final totalLikes = extractedData.extractIntColumn('total_likes');

    final isNsfw = extractedData.extractIntColumn('marked_nsfw')
      .map((isNsfw) => isNsfw != 0)
      .toList();

    final postTimestamp = FormatDate().formatToPostDate(
      data: extractedData, columnName: 'created_at'
    );

    return {
      'tags': tags[0],
      'post_timestamp': postTimestamp[0],
      'total_likes': totalLikes[0],
      'is_nsfw': isNsfw[0]
    };
    
  }

}