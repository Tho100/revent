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

    const query = '''
      SELECT title, body_text, creator, created_at, total_likes, total_comments 
        FROM vent_info
    ''';

    return _fetchVentsData(query);

  }

  Future<Map<String, dynamic>> getFollowingVentsData() async {

    const query = '''
      SELECT v.title, v.body_text, v.creator, v.created_at, v.total_likes, v.total_comments
        FROM vent_info v
          INNER JOIN user_follows_info u ON u.following = v.creator
          WHERE u.follower = :follower
    ''';

    final params = {'follower': userData.user.username};

    return _fetchVentsData(query, params: params);

  }

  Future<Map<String, dynamic>> getSearchVentsData({required String? searchTitleText}) async {

    const query = '''
      SELECT title, creator, created_at, total_likes, total_comments 
        FROM vent_info 
        WHERE LOWER(title) LIKE LOWER(:search_text) OR LOWER(body_text) LIKE LOWER(:search_text)
    ''';

    final params = {'search_text': '%$searchTitleText%'};

    return _fetchVentsData(query, params: params, excludeBodyText: true);

  }

  Future<Map<String, dynamic>> getLikedVentsData() async {

    const query = '''
      SELECT vi.title, vi.body_text, vi.creator, vi.created_at, vi.total_likes, vi.total_comments 
        FROM vent_info vi
          INNER JOIN liked_vent_info lvi 
          ON vi.title = lvi.title AND lvi.liked_by = :liked_by;
    ''';

    final param = {'liked_by': userData.user.username};

    return _fetchVentsData(query, params: param);

  }

  Future<Map<String, dynamic>> _fetchVentsData(
    String query, 
    {Map<String, dynamic>? params, bool excludeBodyText = false}
  ) async {

    final conn = await ReventConnect.initializeConnection();

    final results = params != null 
      ? await conn.execute(query, params)
      : await conn.execute(query);

    final extractedData = ExtractData(rowsData: results);

    final title = extractedData.extractStringColumn('title');

    final bodyText = excludeBodyText
      ? List<String>.generate(title.length, (_) => '')
      : extractedData.extractStringColumn('body_text');

    final creator = extractedData.extractStringColumn('creator');

    final totalLikes = extractedData.extractIntColumn('total_likes');
    final totalComments = extractedData.extractIntColumn('total_comments');

    final postTimestamp = extractedData
      .extractStringColumn('created_at')
      .map((timestamp) => formatPostTimestamp.formatPostTimestamp(DateTime.parse(timestamp)))
      .toList();

    final isLikedState = await _ventPostState(
      conn: conn, title: title, stateType: 'liked'
    );

    final isSavedState = await _ventPostState(
      conn: conn, title: title, stateType: 'saved'
    );

    return {
      'title': title,
      'body_text': bodyText,
      'creator': creator,
      'post_timestamp': postTimestamp,
      'total_likes': totalLikes,
      'total_comments': totalComments,
      'is_liked': isLikedState,
      'is_saved': isSavedState,
    };

  }

  Future<List<bool>> _ventPostState({
    required MySQLConnectionPool conn,
    required List<String> title,
    required String stateType,
  }) async {

    final queryBasedOnType = {
      'liked': 'SELECT title FROM liked_vent_info WHERE liked_by = :liked_by',
      'saved': 'SELECT title FROM saved_vent_info WHERE saved_by = :saved_by'
    };

    final paramBasedOnType = {
      'liked': {'liked_by': userData.user.username},
      'saved': {'saved_by': userData.user.username},
    };

    final retrievedTitles = await conn.execute(
      queryBasedOnType[stateType]!, paramBasedOnType[stateType]
    );

    final extractTitlesData = ExtractData(rowsData: retrievedTitles);

    final postTitles = extractTitlesData.extractStringColumn('title');
    
    final titlesSet = Set<String>.from(postTitles);

    return title.map((t) => titlesSet.contains(t)).toList();

  }

}