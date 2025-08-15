import 'dart:convert';

import 'package:revent/global/table_names.dart';
import 'package:revent/helper/data_converter.dart';
import 'package:revent/shared/provider_mixins.dart';
import 'package:revent/service/query/general/base_query_service.dart';
import 'package:revent/helper/extract_data.dart';
import 'package:revent/helper/format_date.dart';

class ProfileSavedDataGetter extends BaseQueryService with UserProfileProviderService {

  Future<Map<String, List<dynamic>>> getSaved({
    required String username, 
    required bool isMyProfile
  }) async {
// TODO: problem: Cant load profiles saved posts, fix this query

    const query = 
    '''
      SELECT 
        vi.post_id,
        vi.title,
        vi.creator,
        vi.tags,
        vi.body_text,
        vi.total_likes,
        vi.total_comments,
        vi.marked_nsfw,
        vi.created_at,
        upi.profile_picture
      FROM 
        FROM ${TableNames.savedVentInfo} svi
      JOIN 
        FROM ${TableNames.ventInfo} vi 
        ON svi.post_id = vi.post_id
      JOIN 
        FROM ${TableNames.userProfileInfo} upi
        ON vi.creator = upi.username
      WHERE 
        svi.saved_by = :saved_by
      ORDER BY created_at DESC
    ''';

    final param = {'saved_by': username};

    final retrievedInfo = await executeQuery(query, param);

    final extractData = ExtractData(rowsData: retrievedInfo);

    final postIds = extractData.extractIntColumn('post_id');
    final titles = extractData.extractStringColumn('title');
    final bodyText = extractData.extractStringColumn('body_text');
    final tags = extractData.extractStringColumn('tags');
    final creator = extractData.extractStringColumn('creator');

    final totalComments = extractData.extractIntColumn('total_comments');
    final totalLikes = extractData.extractIntColumn('total_likes');

    final postTimestamp = FormatDate().formatToPostDate(
      data: extractData, columnName: 'created_at'
    );

    final profilePicture = extractData
      .extractStringColumn('profile_picture')
      .map((pfpBase64) => base64Decode(pfpBase64))
      .toList();

    final isNsfw = DataConverter.convertToBools(
      extractData.extractIntColumn('marked_nsfw')
    );
    
    final isLikedState = await _ventPostLikeState(
      postIds: postIds, stateType: 'liked'
    );

    final isSavedState = isMyProfile 
      ? List.generate(titles.length, (_) => true)
      : await _ventPostLikeState(
        postIds: postIds, stateType: 'saved'
      );

    return {
      'creator': creator,
      'title': titles,
      'body_text': bodyText,
      'tags': tags,
      'total_likes': totalLikes,
      'total_comments': totalComments,
      'post_timestamp': postTimestamp,
      'profile_picture': profilePicture,
      'is_nsfw': isNsfw,
      'is_liked': isLikedState,
      'is_saved': isSavedState
    };

  }

  Future<List<bool>> _ventPostLikeState({
    required List<int> postIds,
    required String stateType,
  }) async {

    final queryBasedOnType = {
      'liked': 'SELECT post_id FROM ${TableNames.likedVentInfo} WHERE liked_by = :username',
      'saved': 'SELECT post_id FROM ${TableNames.savedVentInfo} WHERE saved_by = :username'
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