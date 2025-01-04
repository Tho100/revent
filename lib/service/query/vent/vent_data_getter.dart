import 'package:mysql_client/mysql_client.dart';
import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/main.dart';
import 'package:revent/service/query/general/base_query_service.dart';
import 'package:revent/service/query/general/post_id_getter.dart';
import 'package:revent/service/revent_connection_service.dart';
import 'package:revent/helper/extract_data.dart';
import 'package:revent/helper/format_date.dart';

class VentDataGetter extends BaseQueryService {

  final formatPostTimestamp = FormatDate();

  final userData = getIt.userProvider;

  Future<Map<String, dynamic>> getVentsData() async {

    const query = '''
      SELECT title, body_text, creator, created_at, total_likes, total_comments 
        FROM vent_info
    ''';

    return _fetchVentsData(query);

  }

  Future<Map<String, dynamic>> getTrendingVentsData() async {

    const query = '''
      SELECT title, body_text, creator, created_at, total_likes, total_comments 
        FROM vent_info 
          ORDER BY (total_likes >= 5 AND total_comments >= 1) ASC, total_likes ASC;
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
          ON vi.post_id = lvi.post_id AND lvi.liked_by = :liked_by;
    ''';

    final param = {'liked_by': userData.user.username};

    return _fetchVentsData(query, params: param);

  }

  Future<Map<String, dynamic>> getSavedVentsData() async {

    const query = '''
      SELECT vi.title, vi.body_text, vi.creator, vi.created_at, vi.total_likes, vi.total_comments 
        FROM vent_info vi
          INNER JOIN saved_vent_info svi 
          ON vi.title = svi.title AND svi.saved_by = :saved_by;
    ''';

    final param = {'saved_by': userData.user.username};

    return _fetchVentsData(query, params: param);

  }

  Future<Map<String, dynamic>> _fetchVentsData(
    String query, 
    {Map<String, dynamic>? params, bool excludeBodyText = false}
  ) async {

    final conn = await ReventConnection.connect(); // TODO: Remove this

    final results = params != null 
      ? await executeQuery(query, params)
      : await executeQuery(query);

    final postIds = await PostIdGetter().getAllPostsId();

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
      conn: conn, postIds: postIds, stateType: 'liked'
    );

    final isSavedState = await _ventPostState(
      conn: conn, postIds: postIds, stateType: 'saved'
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
    required List<int> postIds,
    required String stateType,
  }) async {

    final queryBasedOnType = {
      'liked': 'SELECT post_id FROM liked_vent_info WHERE liked_by = :liked_by',
      'saved': 'SELECT post_id FROM saved_vent_info WHERE saved_by = :saved_by'
    };
    
    final paramBasedOnType = {
      'liked': {'liked_by': userData.user.username},
      'saved': {'saved_by': userData.user.username},
    };

    /*
    TODO: Simplify this by using queryBasedOnType[stateType]!,
    {'username': username},
    
     */

    final retrievedIds = await executeQuery(
      queryBasedOnType[stateType]!,
      paramBasedOnType[stateType],
    );

    final extractIds = ExtractData(rowsData: retrievedIds).extractIntColumn('post_id');

    final statePostIds = extractIds.toSet();

    return postIds.map((postId) => statePostIds.contains(postId)).toList();

  }

}