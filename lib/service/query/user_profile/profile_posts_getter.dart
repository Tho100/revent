import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/main.dart';
import 'package:revent/service/query/general/base_query_service.dart';
import 'package:revent/helper/extract_data.dart';
import 'package:revent/helper/format_date.dart';
import 'package:revent/service/query/general/post_id_getter.dart';

class ProfilePostsDataGetter extends BaseQueryService {

  final formatPostTimestamp = FormatDate();

  final userData = getIt.userProvider;

  Future<Map<String, List<dynamic>>> getPosts({required String username}) async {

    const query = 
      'SELECT title, body_text, total_likes, total_comments, created_at FROM vent_info WHERE creator = :username';
      
    final param = {'username': username};

    final retrievedInfo = await executeQuery(query, param);

    final postIds = await PostIdGetter().getAllPostsId();

    final extractData = ExtractData(rowsData: retrievedInfo);
    
    final title = extractData.extractStringColumn('title');
    final bodyText = extractData.extractStringColumn('body_text');
    final totalLikes = extractData.extractIntColumn('total_likes');
    final totalComments = extractData.extractIntColumn('total_comments');

    final postTimestamp = extractData
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
      'total_likes': totalLikes,
      'total_comments': totalComments,
      'post_timestamp': postTimestamp,
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

    return postIds.map((postId) => statePostIds.contains(postId)).toList().reversed.toList();

  }

}