import 'dart:convert';

import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/main.dart';
import 'package:revent/service/query/general/base_query_service.dart';
import 'package:revent/helper/extract_data.dart';
import 'package:revent/helper/format_date.dart';

class ProfileSavedDataGetter extends BaseQueryService {

  final formatPostTimestamp = FormatDate();

  Future<Map<String, List<dynamic>>> getSaved({
    required String username,
  }) async {

    const query = '''
      SELECT 
        vi.creator,
        vi.title,
        vi.body_text,
        vi.total_likes,
        vi.total_comments,
        vi.created_at,
        upi.profile_picture
      FROM 
        saved_vent_info svi
      JOIN 
        vent_info vi 
        ON svi.title = vi.title AND svi.creator = vi.creator
      JOIN 
        user_profile_info upi
        ON vi.creator = upi.username
      WHERE 
        svi.saved_by = :saved_by
    ''';

    final param = {
      'saved_by': username,
    };

    final retrievedInfo = await executeQuery(query, param);

    final extractData = ExtractData(rowsData: retrievedInfo);
    
    final creator = extractData.extractStringColumn('creator');

    final titles = extractData.extractStringColumn('title');
    final bodyText = extractData.extractStringColumn('body_text');

    final totalComments = extractData.extractIntColumn('total_comments');
    final totalLikes = extractData.extractIntColumn('total_likes');

    final postTimestamp = extractData
      .extractStringColumn('created_at')
      .map((timestamp) => formatPostTimestamp.formatPostTimestamp(DateTime.parse(timestamp)))
      .toList();

    final profilePicture = extractData
      .extractStringColumn('profile_picture')
      .map((pfpBase64) => base64Decode(pfpBase64))
      .toList();

    final isLikedState = await _ventPostLikeState(
      title: titles,
      stateType: 'liked'
    );

    final isSavedState = List.generate(titles.length, (_) => true);

    return {
      'creator': creator,
      'title': titles,
      'body_text': bodyText,
      'total_likes': totalLikes,
      'total_comments': totalComments,
      'post_timestamp': postTimestamp,
      'profile_picture': profilePicture,
      'is_liked': isLikedState,
      'is_saved': isSavedState,
    };

  }

  Future<List<bool>> _ventPostLikeState({
    required List<String> title,
    required String stateType,
  }) async {

    const query = 'SELECT title FROM liked_vent_info WHERE liked_by = :liked_by';

    final param = {
      'liked_by': getIt.userProvider.user.username,
    };

    final retrievedTitles = await executeQuery(query, param);

    final extractTitlesData = ExtractData(rowsData: retrievedTitles);

    final postTitles = extractTitlesData.extractStringColumn('title');
    
    final titlesSet = Set<String>.from(postTitles);

    return title.map((t) => titlesSet.contains(t)).toList();

  }

}