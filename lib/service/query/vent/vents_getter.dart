import 'package:revent/global/table_names.dart';
import 'package:revent/helper/data_converter.dart';
import 'package:revent/shared/provider_mixins.dart';
import 'package:revent/service/query/general/base_query_service.dart';
import 'package:revent/helper/extract_data.dart';
import 'package:revent/helper/format_date.dart';
import 'package:revent/service/query/vent/vent_post_state_service.dart';

class VentsGetter extends BaseQueryService with UserProfileProviderService {

  Future<Map<String, dynamic>> getLatestVentsData() async {

    const query = '''
      SELECT 
        post_id, title, body_text, creator, created_at, tags, total_likes, total_comments, marked_nsfw
      FROM ${TableNames.ventInfo} vi
      WHERE NOT EXISTS (
        SELECT 1
        FROM ${TableNames.userBlockedInfo} ubi
        WHERE ubi.blocked_by = :blocked_by
          AND ubi.blocked_username = vi.creator
      )
      ORDER BY created_at DESC
      LIMIT 25;
    ''';

    final param = {'blocked_by': userProvider.user.username};

    return _fetchVentsData(query, params: param);

  }

  Future<Map<String, dynamic>> getTrendingVentsData() async {

    const query = '''
      SELECT 
        post_id, title, body_text, creator, created_at, tags, total_likes, total_comments, marked_nsfw
      FROM ${TableNames.ventInfo} vi
      WHERE NOT EXISTS (
        SELECT 1
        FROM ${TableNames.userBlockedInfo} ubi
        WHERE ubi.blocked_by = :blocked_by
          AND ubi.blocked_username = vi.creator
      )
        AND vi.created_at >= DATE_SUB(NOW(), INTERVAL 16 DAY)
        AND (total_likes >= 5 OR total_comments >= 1)
      ORDER BY 
        (total_likes >= 5 AND total_comments >= 1) ASC, 
        total_likes ASC, 
        created_at DESC
      LIMIT 25;
    ''';

    final param = {'blocked_by': userProvider.user.username};

    return _fetchVentsData(query, params: param);

  }

  Future<Map<String, dynamic>> getFollowingVentsData() async {

    const query = '''
      SELECT 
        post_id, title, body_text, creator, created_at, tags, total_likes, total_comments, marked_nsfw
      FROM ${TableNames.ventInfo} vi
      INNER JOIN ${TableNames.userFollowsInfo} ufi 
        ON ufi.following = vi.creator
      WHERE ufi.follower = :username
        AND NOT EXISTS (
          SELECT 1
          FROM ${TableNames.userBlockedInfo} ubi
          WHERE ubi.blocked_by = :username
            AND ubi.blocked_username = vi.creator
        )
      ORDER BY created_at DESC
      LIMIT 25;
    ''';

    final param = {'username': userProvider.user.username};

    return _fetchVentsData(query, params: param);

  }

  Future<Map<String, dynamic>> getSearchVentsData({required String? searchText}) async {

    final cleanSearchText = searchText?.replaceAll(RegExp(r'[^\w\s]'), '') ?? '';

    const query = '''
      SELECT 
        post_id, title, creator, created_at, tags, total_likes, total_comments, marked_nsfw
      FROM ${TableNames.ventInfo} vi
      WHERE 
        (LOWER(title) LIKE LOWER(:search_text) 
        OR LOWER(body_text) LIKE LOWER(:search_text) 
        OR LOWER(tags) LIKE LOWER(:search_text))
        AND NOT EXISTS (
          SELECT 1
          FROM ${TableNames.userBlockedInfo} ubi
          WHERE ubi.blocked_by = :blocked_by
            AND ubi.blocked_username = vi.creator
        )
      ORDER BY created_at DESC;
    ''';

    final params = {
      'search_text': '%$cleanSearchText%',
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
        vi.marked_nsfw,
        upi.profile_picture
      FROM 
        liked_FROM ${TableNames.ventInfo} lvi
      JOIN 
        FROM ${TableNames.ventInfo} vi 
        ON lvi.post_id = vi.post_id
      JOIN 
        FROM ${TableNames.userProfileInfo} upi
        ON vi.creator = upi.username
      WHERE 
        lvi.liked_by = :liked_by
      ORDER BY created_at DESC
      LIMIT 25
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
        vi.marked_nsfw,
        upi.profile_picture
      FROM 
        saved_FROM ${TableNames.ventInfo} svi
      JOIN 
        FROM ${TableNames.ventInfo} vi 
        ON svi.post_id = vi.post_id
      JOIN 
        FROM ${TableNames.userProfileInfo} upi
        ON vi.creator = upi.username
      WHERE 
        svi.saved_by = :saved_by
      ORDER BY created_at DESC
      LIMIT 25
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

    final tags = extractedData.extractStringColumn('tags');
    
    final totalLikes = extractedData.extractIntColumn('total_likes');
    final totalComments = extractedData.extractIntColumn('total_comments');

    final postTimestamp = FormatDate().formatToPostDate(
      data: extractedData, columnName: 'created_at'
    );

    final isNsfw = DataConverter.convertToBools(
      extractedData.extractIntColumn('marked_nsfw')
    );
    
    final bodyText = excludeBodyText
      ? List.generate(title.length, (_) => '')
      : List.generate(
        title.length, (index) => isNsfw[index] ? '' : extractedData.extractStringColumn('body_text')[index]
      );

    final ventPostState = VentPostStateService();

    final isLikedState = await ventPostState.getVentPostState(
      postIds: postIds, stateType: 'liked'
    );

    final isSavedState = await ventPostState.getVentPostState(
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
      'is_nsfw': isNsfw,
      'is_liked': isLikedState,
      'is_saved': isSavedState
    };

  }

}