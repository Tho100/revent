import 'package:revent/connection/revent_connect.dart';
import 'package:revent/model/extract_data.dart';
import 'package:revent/model/format_post_timestamp.dart';

class VentDataGetter {

  final formatPostTimestamp = FormatPostTimestamp();

  Future<Map<String, dynamic>> getVentsData() async {

    final conn = await ReventConnect.initializeConnection();

    const query = "SELECT title, body_text, creator, created_at, total_likes, total_comments FROM vent_info";
    
    final retrievedVents = await conn.execute(query);

    final extractData = ExtractData(rowsData: retrievedVents);

    final title = extractData.extractStringColumn('title');
    final bodyText = extractData.extractStringColumn('body_text');
    final creator = extractData.extractStringColumn('creator');

    final totalLikes = extractData.extractIntColumn('total_likes');
    final totalComments = extractData.extractIntColumn('total_comments');

    final postTimestamp = retrievedVents.rows.map((row) {
      final createdAtValue = row.assoc()['created_at'];
      final createdAt = DateTime.parse(createdAtValue!);
      return formatPostTimestamp.formatTimeAgo(createdAt);
    }).toList();

    return {
      'title': title,
      'body_text': bodyText,
      'creator': creator,
      'post_timestamp': postTimestamp,
      'total_likes': totalLikes,
      'total_comments': totalComments,
    };

  }

}