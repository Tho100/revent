import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/main.dart';
import 'package:revent/service/query/general/base_query_service.dart';
import 'package:revent/helper/extract_data.dart';
import 'package:revent/helper/format_date.dart';

class ProfilePostsDataGetter extends BaseQueryService {

  final formatPostTimestamp = FormatDate();

  final userData = getIt.userProvider;

  Future<Map<String, List<dynamic>>> getPosts({
    required String username
  }) async {

    const query = 
      'SELECT title, body_text, total_likes, total_comments, created_at FROM vent_info WHERE creator = :username';
      
    final param = {
      'username': username
    };

    final retrievedInfo = await executeQuery(query, param);

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
      title: title,
      stateType: 'liked'
    );

    final isSavedState = await _ventPostState(
      title: title,
      stateType: 'saved'
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

    final retrievedTitles = await executeQuery(
      queryBasedOnType[stateType]!, paramBasedOnType[stateType]!
    );

    final extractTitlesData = ExtractData(rowsData: retrievedTitles);

    final postTitles = extractTitlesData.extractStringColumn('title');
    
    final titlesSet = Set<String>.from(postTitles);

    return title.map((t) => titlesSet.contains(t)).toList();

  }

}