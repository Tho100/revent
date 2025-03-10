import 'package:revent/helper/providers_service.dart';
import 'package:revent/service/query/general/base_query_service.dart';
import 'package:revent/helper/extract_data.dart';
import 'package:revent/helper/format_date.dart';

class VentDataGetter extends BaseQueryService with UserProfileProviderService {

  final formatPostTimestamp = FormatDate();

  Future<Map<String, dynamic>> getVentsData() async {

    const query = '''
      SELECT 
        post_id, title, body_text, creator, created_at, tags, total_likes, total_comments
      FROM vent_info vi
      LEFT JOIN user_blocked_info ubi
        ON vi.creator = ubi.blocked_username AND ubi.blocked_by = :blocked_by
      WHERE ubi.blocked_username IS NULL
    ''';

    final param = {'blocked_by': userProvider.user.username};

    return _fetchVentsData(query, params: param);

  }

  Future<Map<String, dynamic>> getTrendingVentsData() async {

    const query = '''
      SELECT 
        post_id, title, body_text, creator, created_at, tags, total_likes, total_comments 
      FROM vent_info vi
      LEFT JOIN user_blocked_info ubi
        ON vi.creator = ubi.blocked_username AND ubi.blocked_by = :blocked_by
      WHERE ubi.blocked_username IS NULL
        ORDER BY (total_likes >= 5 AND total_comments >= 1) ASC, total_likes ASC;
    ''';

    final param = {'blocked_by': userProvider.user.username};

    return _fetchVentsData(query, params: param);

  }

  Future<Map<String, dynamic>> getFollowingVentsData() async {

    const query = '''
      SELECT 
        vi.post_id, vi.title, vi.body_text, vi.creator, vi.created_at, vi.tags, vi.total_likes, vi.total_comments
      FROM vent_info vi
      INNER JOIN user_follows_info ufi 
          ON ufi.following = vi.creator
      LEFT JOIN user_blocked_info ubi 
        ON vi.creator = ubi.blocked_username AND ubi.blocked_by = :username
      WHERE ufi.follower = :username AND ubi.blocked_username IS NULL
    ''';

    final param = {'username': userProvider.user.username};

    return _fetchVentsData(query, params: param);

  }

  Future<Map<String, dynamic>> getSearchVentsData({required String? searchTitleText}) async {

    const query = '''
      SELECT 
        post_id, title, creator, created_at, tags, total_likes, total_comments 
      FROM vent_info vi
      LEFT JOIN user_blocked_info ubi
        ON vi.creator = ubi.blocked_username AND ubi.blocked_by = :blocked_by
      WHERE 
        (LOWER(title) LIKE LOWER(:search_text) OR LOWER(body_text) LIKE LOWER(:search_text))
        AND ubi.blocked_username IS NULL;
    ''';

    final params = {
      'search_text': '%$searchTitleText%',
      'blocked_by': userProvider.user.username
    };

    return _fetchVentsData(query, params: params, excludeBodyText: true);

  }

  Future<Map<String, dynamic>> getLikedVentsData() async {

    const query = '''
      SELECT 
        vi.post_id,
        vi.title,
        vi.creator,
        vi.body_text,
        vi.tags, 
        vi.created_at,
        vi.total_likes,
        vi.total_comments,
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

    final param = {'liked_by': userProvider.user.username};

    return _fetchVentsData(query, params: param);

  }

  Future<Map<String, dynamic>> getSavedVentsData() async {

    const query = '''
      SELECT 
        vi.post_id,
        vi.title,
        vi.creator,
        vi.body_text,
        vi.tags, 
        vi.created_at,
        vi.total_likes,
        vi.total_comments,
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

    final param = {'saved_by': userProvider.user.username};

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
      ? List.filled(title.length, '')
      : extractedData.extractStringColumn('body_text');

    final tags = extractedData.extractStringColumn('tags');

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
      'tags': tags,
      'post_timestamp': postTimestamp,
      'creator': creator,
      'total_likes': totalLikes,
      'total_comments': totalComments,
      'is_liked': isLikedState,
      'is_saved': isSavedState
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

    final param = {'username': userProvider.user.username};

    final retrievedIds = await executeQuery(
      queryBasedOnType[stateType]!, param
    );

    final extractIds = ExtractData(rowsData: retrievedIds).extractIntColumn('post_id');

    final statePostIds = extractIds.toSet();

    return postIds.map((postId) => statePostIds.contains(postId)).toList();

  }

}