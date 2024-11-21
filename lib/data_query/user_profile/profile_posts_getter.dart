import 'package:revent/connection/revent_connect.dart';
import 'package:revent/model/extract_data.dart';
import 'package:revent/model/format_date.dart';

class ProfilePostsGetter {

  final formatPostTimestamp = FormatDate();

  Future<Map<String, List<dynamic>>> getPosts({
    required String username
  }) async {

    final conn = await ReventConnect.initializeConnection();

    const query = 'SELECT title, total_likes, total_comments, created_at FROM vent_info WHERE creator = :username';
    final param = {
      'username': username
    };

    final retrievedInfo = await conn.execute(query, param);

    final extractData = ExtractData(rowsData: retrievedInfo);
    
    final title = extractData.extractStringColumn('title');
    final totalLikes = extractData.extractIntColumn('total_likes');
    final totalComments = extractData.extractIntColumn('total_comments');

    final postTimestamp = extractData
      .extractStringColumn('created_at')
      .map((timestamp) => formatPostTimestamp.formatPostTimestamp(DateTime.parse(timestamp)))
      .toList();

    return {
      'title': title,
      'total_likes': totalLikes,
      'total_comments': totalComments,
      'post_timestamp': postTimestamp
    };

  }

}