import 'package:get_it/get_it.dart';
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

    List<bool> isLikedState = [];

    for (int i = 0; i < title.length; i++) {

      const readLikesQuery = 'SELECT title FROM vent_likes_info WHERE liked_by = :liked_by AND creator = :creator';

      final params = {
        'liked_by': userData.user.username,
        'creator': creator[i]
      };

      final retrievedTitles = await conn.execute(readLikesQuery, params);

      final extractTitlesData = ExtractData(rowsData: retrievedTitles);

      final likedPostTitle = extractTitlesData.extractStringColumn('title');
      
      final likedTitlesSet = Set<String>.from(likedPostTitle);

      likedTitlesSet.contains(title[i])
        ? isLikedState.add(true)
        : isLikedState.add(false);

    }

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

}