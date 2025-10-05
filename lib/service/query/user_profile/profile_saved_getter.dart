import 'dart:convert';

import 'package:revent/global/table_names.dart';
import 'package:revent/global/validation_limits.dart';
import 'package:revent/helper/data_converter.dart';
import 'package:revent/helper/format_previewer_body.dart';
import 'package:revent/shared/provider_mixins.dart';
import 'package:revent/service/query/general/base_query_service.dart';
import 'package:revent/helper/extract_data.dart';
import 'package:revent/helper/format_date.dart';

class ProfileSavedDataGetter extends BaseQueryService with UserProfileProviderService {
// TODO: Remove the class and move this func to profile_posts_getter
  Future<Map<String, List<dynamic>>> getSaved({
    required String username, 
    required bool isMyProfile
  }) async {

    const query = 
    '''
      SELECT 
        vi.post_id,
        vi.title,
        vi.creator,
        vi.tags,
        LEFT(vi.body_text, ${ValidationLimits.maxBodyPreviewerLength}) as body_text,
        vi.total_likes,
        vi.total_comments,
        vi.marked_nsfw,
        vi.created_at,
        upi.profile_picture
      FROM 
        ${TableNames.savedVentInfo} svi
      INNER JOIN 
        ${TableNames.ventInfo} vi 
        ON svi.post_id = vi.post_id
      INNER JOIN 
        ${TableNames.userProfileInfo} upi
        ON vi.creator = upi.username
      WHERE 
        svi.saved_by = :saved_by
      ORDER BY svi.saved_at DESC
    ''';

    final param = {'saved_by': username};

    final retrievedInfo = await executeQuery(query, param);

    final extractedData = ExtractData(rowsData: retrievedInfo);

    final postIds = extractedData.extractIntColumn('post_id');
    final titles = extractedData.extractStringColumn('title');
    final tags = extractedData.extractStringColumn('tags');
    final creator = extractedData.extractStringColumn('creator');

    final totalComments = extractedData.extractIntColumn('total_comments');
    final totalLikes = extractedData.extractIntColumn('total_likes');

    final postTimestamp = FormatDate().formatToPostDate(
      data: extractedData, columnName: 'created_at'
    );

    final profilePicture = extractedData
      .extractStringColumn('profile_picture')
      .map((pfpBase64) => base64Decode(pfpBase64))
      .toList();

    final isNsfw = DataConverter.convertToBools(
      extractedData.extractIntColumn('marked_nsfw')
    );

    final bodyText = extractedData.extractStringColumn('body_text');

    final modifiedBodyText = List.generate(
      titles.length, (index) => FormatPreviewerBody.formatBodyText(
        bodyText: bodyText[index], isNsfw: isNsfw[index]
      )
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
      'post_id': postIds,
      'title': titles,
      'creator': creator,
      'body_text': modifiedBodyText,
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