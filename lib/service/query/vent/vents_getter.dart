import 'package:revent/helper/data/data_converter.dart';
import 'package:revent/helper/data/extract_data.dart';
import 'package:revent/helper/format/format_date.dart';
import 'package:revent/helper/format/format_previewer_body.dart';
import 'package:revent/shared/api/api_client.dart';
import 'package:revent/shared/api/api_path.dart';
import 'package:revent/shared/provider_mixins.dart';

class VentsGetter with UserProfileProviderService {

  Future<Map<String, dynamic>> _returnVentsInfo(String apiPath) async {

    final response = await ApiClient.get(apiPath, userProvider.user.username);

    return await _parseVentsData(ventsBody: response.body);

  }

  Future<Map<String, dynamic>> getLatestVentsData() async {
    return _returnVentsInfo(ApiPath.latestVentsGetter);
  }

  Future<Map<String, dynamic>> getTrendingVentsData() async {
    return _returnVentsInfo(ApiPath.trendingVentsGetter);

  }

  Future<Map<String, dynamic>> getFollowingVentsData() async {
    return _returnVentsInfo(ApiPath.followingVentsGetter);

  }

  Future<Map<String, dynamic>> getLikedVentsData() async {
    return _returnVentsInfo(ApiPath.likedVentsGetter);

  }

  Future<Map<String, dynamic>> getSavedVentsData() async {
    return _returnVentsInfo(ApiPath.savedVentsGetter);

  }

  Future<Map<String, dynamic>> getSearchVentsData({required String? searchText}) async {        

    final cleanSearchText = searchText?.replaceAll(RegExp(r'[^\w\s]'), '') ?? '';

    final response = await ApiClient.post(ApiPath.searchVentsGetter, {
      'search_text': cleanSearchText,
      'current_user': userProvider.user.username
    }); 

    return await _parseVentsData(ventsBody: response.body, excludeBodyText: true);

  }

  Future<Map<String, dynamic>> _parseVentsData({
    required dynamic ventsBody, 
    bool excludeBodyText = false
  }) async {

    final vents = ventsBody['vents'];

    final ventsData = ExtractData(data: vents);

    final postIds = ventsData.extractColumn<int>('post_id');
    
    final titles = ventsData.extractColumn<String>('title');
    final creators = ventsData.extractColumn<String>('creator');
    final tags = ventsData.extractColumn<String>('tags');

    final totalLikes = ventsData.extractColumn<int>('total_likes');
    final totalComments = ventsData.extractColumn<int>('total_comments');

    final postTimestamp = FormatDate().formatToPostDate(
      ventsData.extractColumn<String>('created_at')
    );

    final profilePictures = DataConverter.convertToPfp(
      ventsData.extractColumn<String>('profile_picture')
    );

    final isNsfw = DataConverter.convertToBools(
      ventsData.extractColumn<int>('marked_nsfw')
    );

    final bodyText = excludeBodyText
      ? const []
      : ventsData.extractColumn<String>('body_text');

    final modifiedBodyText = excludeBodyText
      ? List.generate(titles.length, (_) => '')
      : List.generate(
          titles.length,
          (index) => FormatPreviewerBody.formatBodyText(
            bodyText: bodyText[index],
            isNsfw: isNsfw[index],
          ),
        );

    final isLiked = ventsData.extractColumn<bool>('is_liked');
    final isSaved = ventsData.extractColumn<bool>('is_saved');

    return {
      'post_id': postIds,
      'title': titles,
      'body_text': modifiedBodyText,
      'tags': tags,
      'post_timestamp': postTimestamp,
      'creator': creators,
      'profile_picture': profilePictures,
      'total_likes': totalLikes,
      'total_comments': totalComments,
      'is_nsfw': isNsfw,
      'is_liked': isLiked,
      'is_saved': isSaved
    };

  }

}