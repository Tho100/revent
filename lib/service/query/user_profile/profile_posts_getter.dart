import 'package:revent/global/table_names.dart';
import 'package:revent/global/validation_limits.dart';
import 'package:revent/helper/data_converter.dart';
import 'package:revent/helper/format_previewer_body.dart';
import 'package:revent/shared/provider_mixins.dart';
import 'package:revent/service/query/general/base_query_service.dart';
import 'package:revent/helper/extract_data.dart';
import 'package:revent/helper/format_date.dart';
import 'package:revent/service/query/vent/vent_post_state_service.dart';

class ProfilePostsDataGetter extends BaseQueryService with UserProfileProviderService {

  Future<Map<String, List<dynamic>>> getPosts({required String username}) async {

    const query = 
    '''
      SELECT post_id, title, LEFT(body_text, ${ValidationLimits.maxBodyPreviewerLength}), tags, created_at, total_likes, total_comments, marked_nsfw 
      FROM ${TableNames.ventInfo} 
      WHERE creator = :username
      ORDER BY created_at DESC
    ''';
      
    final param = {'username': username};

    final retrievedInfo = await executeQuery(query, param);

    final extractedData = ExtractData(rowsData: retrievedInfo);
    
    final postIds = extractedData.extractIntColumn('post_id');
    final titles = extractedData.extractStringColumn('title');
    final tags = extractedData.extractStringColumn('tags');

    final totalLikes = extractedData.extractIntColumn('total_likes');
    final totalComments = extractedData.extractIntColumn('total_comments');

    final postTimestamp = FormatDate().formatToPostDate(
      data: extractedData, columnName: 'created_at'
    );

    final isNsfw = DataConverter.convertToBools(
      extractedData.extractIntColumn('marked_nsfw')
    );

    final bodyText = extractedData.extractStringColumn('body_text');

    final modifiedBodyText = List.generate(
      titles.length, (index) => FormatPreviewerBody.formatBodyText(
        bodyText: bodyText[index], isNsfw: isNsfw[index]
      )
    );

    final isPinned = await _ventPinnedState(postIds: postIds);

    final ventPostState = VentPostStateService();    

    final isLikedState = await ventPostState.getVentPostState(
      postIds: postIds, stateType: 'liked'
    );

    final isSavedState = await ventPostState.getVentPostState(
      postIds: postIds, stateType: 'saved'
    );

    return {
      'title': titles,
      'body_text': modifiedBodyText,
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

    const query = 'SELECT post_id FROM ${TableNames.pinnedVentInfo} WHERE pinned_by = :username';

    final param = {'username': userProvider.user.username};

    final retrievedIds = await executeQuery(query, param);

    final extractIds = ExtractData(rowsData: retrievedIds).extractIntColumn('post_id');

    final statePostIds = extractIds.toSet();

    return postIds.map((postId) => statePostIds.contains(postId)).toList();

  }

}