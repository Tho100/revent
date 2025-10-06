import 'package:revent/helper/data_converter.dart';
import 'package:revent/helper/format_previewer_body.dart';
import 'package:revent/shared/api/api_client.dart';
import 'package:revent/shared/api/api_path.dart';
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

    final response = await ApiClient.post(ApiPath.profileSavedPostsGetter, {
      'profile_username': username,
      'current_user': userProvider.user.username,
    });

    final vents = ExtractData(data: response.body!['vents']);

    final postIds = vents.extractColumn<int>('post_id');

    final creators = vents.extractColumn<String>('creator');
    final titles = vents.extractColumn<String>('title');
    final tags = vents.extractColumn<String>('tags');

    final totalLikes = vents.extractColumn<int>('total_likes');
    final totalComments = vents.extractColumn<int>('total_comments');

    final postTimestamp = FormatDate().formatToPostDate2(
      vents.extractColumn<String>('created_at')
    );

    final profilePictures = DataConverter.convertToPfp(
      vents.extractColumn<String>('profile_picture')
    );

    final isNsfw = DataConverter.convertToBools(
      vents.extractColumn<int>('marked_nsfw')
    );

    final bodyText = vents.extractColumn<String>('body_text');

    final modifiedBodyText = List.generate(
      titles.length, (index) => FormatPreviewerBody.formatBodyText(
        bodyText: bodyText[index], isNsfw: isNsfw[index]
      )
    );

    final isLiked = vents.extractColumn<bool>('is_liked');
    final isSaved = vents.extractColumn<bool>('is_saved');

    return {
      'post_id': postIds,
      'title': titles,
      'creator': creators,
      'body_text': modifiedBodyText,
      'tags': tags,
      'total_likes': totalLikes,
      'total_comments': totalComments,
      'post_timestamp': postTimestamp,
      'profile_picture': profilePictures,
      'is_nsfw': isNsfw,
      'is_liked': isLiked,
      'is_saved': isSaved
    };

  }

}