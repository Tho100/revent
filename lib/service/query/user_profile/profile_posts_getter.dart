import 'package:revent/helper/providers_service.dart';
import 'package:revent/service/query/general/base_query_service.dart';
import 'package:revent/helper/extract_data.dart';
import 'package:revent/helper/format_date.dart';
import 'package:revent/service/vent_post_state_service.dart';

class ProfilePostsDataGetter extends BaseQueryService with UserProfileProviderService {

  final formatPostTimestamp = FormatDate();

  final ventPostState = VentPostStateService();

  Future<Map<String, List<dynamic>>> getPosts({required String username}) async {

    const query = 
    '''
      SELECT post_id, title, body_text, tags, created_at, total_likes, total_comments, marked_nsfw 
      FROM vent_info 
      WHERE creator = :username
      ORDER BY created_at DESC
    ''';
      
    final param = {'username': username};

    final retrievedInfo = await executeQuery(query, param);

    final extractData = ExtractData(rowsData: retrievedInfo);
    
    final postIds = extractData.extractIntColumn('post_id');
    final title = extractData.extractStringColumn('title');
    final bodyText = extractData.extractStringColumn('body_text');
    final tags = extractData.extractStringColumn('tags');

    final totalLikes = extractData.extractIntColumn('total_likes');
    final totalComments = extractData.extractIntColumn('total_comments');

    final postTimestamp = extractData
      .extractStringColumn('created_at')
      .map((timestamp) => formatPostTimestamp.formatPostTimestamp(DateTime.parse(timestamp)))
      .toList();

    final isNsfw = extractData.extractIntColumn('marked_nsfw')
      .map((isNsfw) => isNsfw != 0)
      .toList();

    final isPinned = await _ventPinnedState(postIds: postIds);

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
      'total_likes': totalLikes,
      'total_comments': totalComments,
      'post_timestamp': postTimestamp,
      'is_nsfw': isNsfw,
      'is_pinned': isPinned,
      'is_liked': isLikedState,
      'is_saved': isSavedState
    };

  }

  Future<List<bool>> _ventPinnedState({required List<int> postIds}) async {

    const query = 'SELECT post_id FROM pinned_vent_info WHERE pinned_by = :username';

    final param = {'username': userProvider.user.username};

    final retrievedIds = await executeQuery(query, param);

    final extractIds = ExtractData(rowsData: retrievedIds).extractIntColumn('post_id');

    final statePostIds = extractIds.toSet();

    return postIds.map((postId) => statePostIds.contains(postId)).toList();

  }

}