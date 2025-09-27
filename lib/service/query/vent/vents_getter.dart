import 'package:revent/helper/data_converter.dart';
import 'package:revent/helper/extract_data.dart';
import 'package:revent/helper/format_previewer_body.dart';
import 'package:revent/shared/api/api_client.dart';
import 'package:revent/shared/api/api_path.dart';
import 'package:revent/shared/provider_mixins.dart';
import 'package:revent/service/query/general/base_query_service.dart';
import 'package:revent/helper/format_date.dart';
import 'package:revent/service/query/vent/vent_post_state_service.dart';

class VentsGetter extends BaseQueryService with UserProfileProviderService {

  Future<Map<String, dynamic>> getLatestVentsData() async {

    final response = await ApiClient.post(ApiPath.latestVentsGetter, {
      'blocked_by': userProvider.user.username
    });

    return await _parseVentsData(ventsBody: response.body);

  }

  Future<Map<String, dynamic>> getTrendingVentsData() async {

    final response = await ApiClient.post(ApiPath.trendingVentsGetter, {
      'blocked_by': userProvider.user.username
    });

    return await _parseVentsData(ventsBody: response.body);

  }

  Future<Map<String, dynamic>> getFollowingVentsData() async {

    final response = await ApiClient.post(ApiPath.followingVentsGetter, {
      'blocked_by': userProvider.user.username
    });

    return await _parseVentsData(ventsBody: response.body);

  }

  Future<Map<String, dynamic>> getSearchVentsData({required String? searchText}) async {        

    final cleanSearchText = searchText?.replaceAll(RegExp(r'[^\w\s]'), '') ?? '';

    final response = await ApiClient.post(ApiPath.searchVentsGetter, {
      'search_text': cleanSearchText,
      'blocked_by': userProvider.user.username
    }); 

    return await _parseVentsData(ventsBody: response.body, excludeBodyText: true);

  }

  Future<Map<String, dynamic>> getLikedVentsData() async {

    final response = await ApiClient.post(ApiPath.likedVentsGetter, {
      'liked_by': userProvider.user.username
    });

    return await _parseVentsData(ventsBody: response.body); 

  }

  Future<Map<String, dynamic>> getSavedVentsData() async {

    final response = await ApiClient.post(ApiPath.savedVentsGetter, {
      'saved_by': userProvider.user.username
    });

    return await _parseVentsData(ventsBody: response.body);

  }

  Future<Map<String, dynamic>> _parseVentsData({
    required dynamic ventsBody, 
    bool excludeBodyText = false
  }) async {

    final vents = ventsBody['vents'] as List<dynamic>;

    final ventsData = ExtractData(data: vents);

    final postIds = ventsData.extractVentsData<int>('post_id');
    
    final titles = ventsData.extractVentsData<String>('title');
    final creators = ventsData.extractVentsData<String>('creator');
    final tags = ventsData.extractVentsData<String>('tags');

    final totalLikes = ventsData.extractVentsData<int>('total_likes');
    final totalComments = ventsData.extractVentsData<int>('total_comments');

    final postTimestamp = FormatDate().formatToPostDate2(
      data: ventsData.extractVentsData<String>('created_at'),
    );

    final isNsfw = DataConverter.convertToBools(
      ventsData.extractVentsData<int>('marked_nsfw'),
    );

    final bodyText = excludeBodyText
      ? const []
      : ventsData.extractVentsData<String>('body_text');

    final modifiedBodyText = excludeBodyText
      ? List.generate(titles.length, (_) => '')
      : List.generate(
          titles.length,
          (index) => FormatPreviewerBody.formatBodyText(
            bodyText: bodyText[index],
            isNsfw: isNsfw[index],
          ),
        );

    final ventPostState = VentPostStateService();

    final isLikedState = await ventPostState.getVentPostState(
      postIds: postIds, stateType: 'liked'
    );

    final isSavedState = await ventPostState.getVentPostState(
      postIds: postIds, stateType: 'saved'
    );

    return {
      'post_id': postIds,
      'title': titles,
      'body_text': modifiedBodyText,
      'tags': tags,
      'post_timestamp': postTimestamp,
      'creator': creators,
      'total_likes': totalLikes,
      'total_comments': totalComments,
      'is_nsfw': isNsfw,
      'is_liked': isLikedState,
      'is_saved': isSavedState
    };

  }

}