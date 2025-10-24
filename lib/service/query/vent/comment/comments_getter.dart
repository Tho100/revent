import 'package:revent/helper/data/data_converter.dart';
import 'package:revent/shared/api/api_client.dart';
import 'package:revent/shared/api/api_path.dart';
import 'package:revent/shared/provider_mixins.dart';
import 'package:revent/helper/data/extract_data.dart';
import 'package:revent/helper/format/format_date.dart';

class CommentsGetter with UserProfileProviderService, VentProviderService {

  Future<Map<String, List<dynamic>>> getComments() async {

    final response = await ApiClient.post(ApiPath.commentsGetter, {
      'post_id': activeVentProvider.ventData.postId,
      'creator': activeVentProvider.ventData.creator,
      'current_user': userProvider.user.username,
      'blocked_by': userProvider.user.username,
    });

    final commentsData = ExtractData(data: response.body!['comments']);

    final comment = commentsData.extractColumn<String>('comment');
    final commentedBy = commentsData.extractColumn<String>('commented_by');

    final totalLikes = commentsData.extractColumn<int>('total_likes');
    final totalReplies = commentsData.extractColumn<int>('total_replies');

    final commentTimestamp = FormatDate().formatToPostDate(
      commentsData.extractColumn<String>('created_at')
    );

    final profilePictures = DataConverter.convertToPfp(
      commentsData.extractColumn<String>('profile_picture')
    );

    final isLiked = commentsData.extractColumn<bool>('is_liked');
    final isLikedByCreator = commentsData.extractColumn<bool>('is_liked_by_creator');

    final isPinned = commentsData.extractColumn<bool>('is_pinned');
    final isEdited = commentsData.extractColumn<bool>('is_edited');

    return {
      'commented_by': commentedBy,
      'comment': comment,
      'comment_timestamp': commentTimestamp,
      'total_likes': totalLikes,
      'total_replies': totalReplies,
      'is_liked': isLiked,
      'is_liked_by_creator': isLikedByCreator,
      'is_pinned': isPinned,
      'is_edited': isEdited,
      'profile_picture': profilePictures,
    };

  }

}