import 'package:revent/connection/revent_connect.dart';
import 'package:revent/model/extract_data.dart';
import 'package:revent/model/format_date.dart';

class ArchiveVentDataGetter {

  final formatPostTimestamp = FormatDate();

  Future<Map<String, List<dynamic>>> getPosts({
    required String username
  }) async {

    final conn = await ReventConnect.initializeConnection();

    const query = 'SELECT title, created_at FROM archive_vent_info WHERE creator = :username';
    final param = {
      'username': username
    };

    final retrievedInfo = await conn.execute(query, param);

    final extractData = ExtractData(rowsData: retrievedInfo);
    
    final title = extractData.extractStringColumn('title');

    final postTimestamp = extractData
      .extractStringColumn('created_at')
      .map((timestamp) => formatPostTimestamp.formatPostTimestamp(DateTime.parse(timestamp)))
      .toList();

    return {
      'title': title,
      'post_timestamp': postTimestamp
    };

  }

  Future<String> getBodyText({
    required String title,
    required String creator
  }) async {

    final conn = await ReventConnect.initializeConnection();

    const query = 
      'SELECT body_text FROM archive_vent_info WHERE title = :title AND creator = :creator';
      
    final params = {
      'title': title,
      'creator': creator
    };

    final results = await conn.execute(query, params);

    return results.rows.last.assoc()['body_text']!;

  }

}