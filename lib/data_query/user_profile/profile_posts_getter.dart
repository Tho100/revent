import 'package:revent/connection/revent_connect.dart';
import 'package:revent/model/extract_data.dart';
import 'package:revent/model/format_date.dart';

class ProfilePostsDataGetter {

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

  Future<Map<String, dynamic>> getBodyText({
    required String title,
    required String creator
  }) async {

    final conn = await ReventConnect.initializeConnection();

    const query = 
      'SELECT body_text FROM vent_info WHERE title = :title AND creator = :creator';
      
    final params = {
      'title': title,
      'creator': creator
    };

    final results = await conn.execute(query, params);

    final extractData = ExtractData(rowsData: results);

    final bodyText = extractData.extractStringColumn('body_text')[0];
      
    return {
      'body_text': bodyText,
    };

  }

}