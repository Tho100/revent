import 'package:revent/helper/data/data_converter.dart';
import 'package:revent/helper/format/format_date.dart';
import 'package:revent/helper/format/format_previewer_body.dart';
import 'package:revent/shared/api/api_client.dart';
import 'package:revent/shared/api/api_path.dart';
import 'package:revent/shared/provider_mixins.dart';
import 'package:revent/helper/data/extract_data.dart';

class ProfilePostsService with UserProfileProviderService {

  final String username;

  ProfilePostsService({required this.username});

  Future<Map<String, List<dynamic>>> getOwnPosts() async {

    final response = await ApiClient.post(ApiPath.profileOwnPostsGetter, {
      'profile_username': username,
      'current_user': userProvider.user.username,
    });

    final vents = ExtractData(data: response.body!['vents']);

    final postIds = vents.extractColumn<int>('post_id');
    final titles = vents.extractColumn<String>('title');
    final tags = vents.extractColumn<String>('tags');

    final totalLikes = vents.extractColumn<int>('total_likes');
    final totalComments = vents.extractColumn<int>('total_comments');

    final postTimestamp = FormatDate().formatToPostDate(
      vents.extractColumn<String>('created_at')
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

    final isPinned = vents.extractColumn<bool>('is_pinned');
    final isLiked = vents.extractColumn<bool>('is_liked');
    final isSaved = vents.extractColumn<bool>('is_saved');

    return {
      'post_id': postIds,
      'title': titles,
      'body_text': modifiedBodyText,
      'tags': tags,
      'total_likes': totalLikes,
      'total_comments': totalComments,
      'post_timestamp': postTimestamp,
      'is_nsfw': isNsfw,
      'is_pinned': isPinned,
      'is_liked': isLiked,
      'is_saved': isSaved
    };

  }

  Future<Map<String, List<dynamic>>> getSavedPosts() async {

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

    final postTimestamp = FormatDate().formatToPostDate(
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