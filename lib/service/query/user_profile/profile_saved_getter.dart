import 'dart:convert';

import 'package:revent/helper/providers_service.dart';
import 'package:revent/service/query/general/base_query_service.dart';
import 'package:revent/helper/extract_data.dart';
import 'package:revent/helper/format_date.dart';

class ProfileSavedDataGetter extends BaseQueryService with UserProfileProviderService {

  final formatPostTimestamp = FormatDate();

  Future<Map<String, List<dynamic>>> getSaved({required String username}) async {

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

    final param = {'saved_by': username};

    final retrievedInfo = await executeQuery(query, param);

    final extractData = ExtractData(rowsData: retrievedInfo);

    final postIds = extractData.extractIntColumn('post_id');
    final titles = extractData.extractStringColumn('title');
    final creator = extractData.extractStringColumn('creator');
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
      postIds: postIds, stateType: 'liked'
    );

    final isSavedState = await _ventPostLikeState(
      postIds: postIds, stateType: 'saved'
    );

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