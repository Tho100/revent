import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/main.dart';
import 'package:revent/service/query/general/base_query_service.dart';
import 'package:revent/helper/extract_data.dart';
import 'package:revent/helper/format_date.dart';

class VentDataGetter extends BaseQueryService {

  final formatPostTimestamp = FormatDate();

  final userData = getIt.userProvider;

  Future<Map<String, dynamic>> getVentsData() async {

    const query = '''
      SELECT post_id, title, body_text, creator, created_at, total_likes, total_comments 
        FROM vent_info
    ''';

    return _fetchVentsData(query);

  }

  Future<Map<String, dynamic>> getTrendingVentsData() async {

    const query = '''
      SELECT post_id, title, body_text, creator, created_at, total_likes, total_comments 
        FROM vent_info 
          ORDER BY (total_likes >= 5 AND total_comments >= 1) ASC, total_likes ASC;
    ''';

    return _fetchVentsData(query);

  }

  Future<Map<String, dynamic>> getFollowingVentsData() async {

    const query = '''
      SELECT v.post_id, v.title, v.body_text, v.creator, v.created_at, v.total_likes, v.total_comments
        FROM vent_info v
          INNER JOIN user_follows_info u ON u.following = v.creator
          WHERE u.follower = :follower
    ''';

    final params = {'follower': userData.user.username};

    return _fetchVentsData(query, params: params);

  }

  Future<Map<String, dynamic>> getSearchVentsData({required String? searchTitleText}) async {

    const query = '''
      SELECT post_id, title, creator, created_at, total_likes, total_comments 
        FROM vent_info 
        WHERE LOWER(title) LIKE LOWER(:search_text) OR LOWER(body_text) LIKE LOWER(:search_text)
    ''';

    final params = {'search_text': '%$searchTitleText%'};

    return _fetchVentsData(query, params: params, excludeBodyText: true);

  }

  Future<Map<String, dynamic>> getLikedVentsData() async {

    const query = '''
      SELECT 
        vi.post_id,
        vi.title,
        vi.creator,
        vi.body_text,
        vi.total_likes,
        vi.total_comments,
        vi.created_at,
        upi.profile_picture
      FROM 
        liked_vent_info lvi
      JOIN 
        vent_info vi 
        ON lvi.post_id = vi.post_id
      JOIN 
        user_profile_info upi
        ON vi.creator = upi.username
      WHERE 
        lvi.liked_by = :liked_by
    ''';

    final param = {'liked_by': userData.user.username};

    return _fetchVentsData(query, params: param);

  }

  Future<Map<String, dynamic>> getSavedVentsData() async {

    const query = '''
      SELECT 
        vi.post_id,
        vi.title,
        vi.creator,
        vi.body_text,
        vi.total_likes,
        vi.total_comments,
        vi.created_at,
        upi.profile_picture
      FROM 
        saved_vent_info svi
      JOIN 
        vent_info vi 
        ON svi.post_id = vi.post_id
      JOIN 
        user_profile_info upi
        ON vi.creator = upi.username
      WHERE 
        svi.saved_by = :saved_by
    ''';

    final param = {'saved_by': userData.user.username};

    return _fetchVentsData(query, params: param);

  }

  Future<Map<String, dynamic>> _fetchVentsData(
    String query, 
    {Map<String, dynamic>? params, bool excludeBodyText = false}
  ) async {

    final results = params != null 
      ? await executeQuery(query, params)
      : await executeQuery(query);

    final extractedData = ExtractData(rowsData: results);

    final postIds = extractedData.extractIntColumn('post_id');
    final title = extractedData.extractStringColumn('title');
    final creator = extractedData.extractStringColumn('creator');

    final bodyText = excludeBodyText
      ? List<String>.generate(title.length, (_) => '')
      : extractedData.extractStringColumn('body_text');

    final totalLikes = extractedData.extractIntColumn('total_likes');
    final totalComments = extractedData.extractIntColumn('total_comments');

    final postTimestamp = extractedData
      .extractStringColumn('created_at')
      .map((timestamp) => formatPostTimestamp.formatPostTimestamp(DateTime.parse(timestamp)))
      .toList();

    final isLikedState = await _ventPostState(
      postIds: postIds, stateType: 'liked'
    );

    final isSavedState = await _ventPostState(
      postIds: postIds, stateType: 'saved'
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
    required List<int> postIds,
    required String stateType,
  }) async {

    final queryBasedOnType = {
      'liked': 'SELECT post_id FROM liked_vent_info WHERE liked_by = :username',
      'saved': 'SELECT post_id FROM saved_vent_info WHERE saved_by = :username'
    };

    final param = {'username': userData.user.username};

    final retrievedIds = await executeQuery(
      queryBasedOnType[stateType]!, param
    );

    final extractIds = ExtractData(rowsData: retrievedIds).extractIntColumn('post_id');

    final statePostIds = extractIds.toSet();

    return postIds.map((postId) => statePostIds.contains(postId)).toList();

  }

}