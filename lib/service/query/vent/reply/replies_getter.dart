import 'package:revent/helper/data/data_converter.dart';
import 'package:revent/shared/api/api_client.dart';
import 'package:revent/shared/api/api_path.dart';
import 'package:revent/shared/provider_mixins.dart';
import 'package:revent/helper/data/extract_data.dart';
import 'package:revent/helper/format/format_date.dart';

class RepliesGetter with UserProfileProviderService, VentProviderService {

  final int commentId;

  RepliesGetter({required this.commentId});

  Future<Map<String, List<dynamic>>> getReplies() async {

    final response = await ApiClient.post(ApiPath.repliesGetter, {
      'comment_id': commentId,
      'creator': activeVentProvider.ventData.creator,
      'current_user': userProvider.user.username,
      'blocked_by': userProvider.user.username
    });

    final replies = ExtractData(data: response.body!['replies']);

    final reply = replies.extractColumn<String>('reply');
    final repliedBy = replies.extractColumn<String>('replied_by');
    final totalLikes = replies.extractColumn<int>('total_likes');

    final replyTimestamp = FormatDate().formatToPostDate(
      replies.extractColumn<String>('created_at')
    );

    final profilePictures = DataConverter.convertToPfp(
      replies.extractColumn<String>('profile_picture')
    );

    final isLiked = replies.extractColumn<bool>('is_liked');
    final isLikedByCreator = replies.extractColumn<bool>('is_liked_by_creator');

    return {
      'replied_by': repliedBy,
      'reply': reply,
      'reply_timestamp': replyTimestamp,
      'total_likes': totalLikes,
      'is_liked': isLiked,
      'is_liked_by_creator': isLikedByCreator,
      'profile_picture': profilePictures,
    };

  }

}