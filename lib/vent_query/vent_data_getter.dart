import 'package:mysql_client/mysql_client.dart';
import 'package:revent/connection/revent_connect.dart';
import 'package:revent/model/format_post_timestamp.dart';

class VentDataGetter {

  final formatPostTimestamp = FormatPostTimestamp();

  List<String> _extractStringColumn(IResultSet rowsData, String columnName) {
    return rowsData.rows.map((row) {
      return row.assoc()[columnName]!;
    }).toList();
  }

  List<int> _extractIntColumn(IResultSet rowsData, String columnName) {
    return rowsData.rows.map((row) {
      final value = row.assoc()[columnName]!;
      return int.tryParse(value) ?? 0;
    }).toList();
  }

  Future<Map<String, dynamic>> getVentsData() async {

    final conn = await ReventConnect.initializeConnection();

    const query = "SELECT title, body_text, creator, created_at, total_likes, total_comments FROM vent_info ORDER BY post_id DESC";
    
    final retrievedVents = await conn.execute(query);

    final title = _extractStringColumn(retrievedVents, 'title');
    final bodyText = _extractStringColumn(retrievedVents, 'body_text');
    final creator = _extractStringColumn(retrievedVents, 'creator');

    final totalLikes = _extractIntColumn(retrievedVents, 'total_likes');
    final totalComments = _extractIntColumn(retrievedVents, 'total_comments');

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