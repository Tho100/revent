import 'package:get_it/get_it.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:revent/connection/revent_connect.dart';
import 'package:revent/model/extract_data.dart';
import 'package:revent/model/format_date.dart';
import 'package:revent/provider/user_data_provider.dart';

class VentDataGetter {

  final formatPostTimestamp = FormatDate();

  final userData = GetIt.instance<UserDataProvider>();

  Future<Map<String, dynamic>> getVentsData() async {

    final conn = await ReventConnect.initializeConnection();

    const query = 'SELECT title, body_text, creator, created_at, total_likes, total_comments FROM vent_info';
    
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
      return formatPostTimestamp.formatPostTimestamp(createdAt);
    }).toList();

    final isLikedState = await _ventPostLikedState(
      conn: conn,
      title: title,
    );

    return {
      'title': title,
      'body_text': bodyText,
      'creator': creator,
      'post_timestamp': postTimestamp,
      'total_likes': totalLikes,
      'total_comments': totalComments,
      'is_liked': isLikedState
    };

  }

  Future<Map<String, dynamic>> getProfilePostsVentData({
    required String title,
    required String creator
  }) async {

    final conn = await ReventConnect.initializeConnection();

    const query = 'SELECT body_text, created_at, total_comments FROM vent_info WHERE title = :title AND creator = :creator';
    final params = {
      'title': title,
      'creator': creator
    };

    final results = await conn.execute(query, params);

    final extractData = ExtractData(rowsData: results);

    final bodyText = extractData.extractStringColumn('body_text')[0];
    final totalComments = extractData.extractIntColumn('total_comments')[0];
    
    final retrievedPostTimestamp = results.rows.last.assoc()['created_at'];
    final createdAt = DateTime.parse(retrievedPostTimestamp!);
    final postTimestamp = formatPostTimestamp.formatPostTimestamp(createdAt);

    return {
      'body_text': bodyText,
      'post_timestamp': postTimestamp,
      'total_comments': totalComments,
    };

  }

  Future<List<bool>> _ventPostLikedState({
    required MySQLConnectionPool conn,
    required List<String> title,
  }) async {

    const readLikesQuery = 'SELECT title FROM vent_likes_info WHERE liked_by = :liked_by';

    final params = {
      'liked_by': userData.user.username,
    };

    final retrievedTitles = await conn.execute(readLikesQuery, params);

    final extractTitlesData = ExtractData(rowsData: retrievedTitles);

    final likedPostTitle = extractTitlesData.extractStringColumn('title');
    
    final likedTitlesSet = Set<String>.from(likedPostTitle);

    return title.map((t) => likedTitlesSet.contains(t)).toList();

  }

}