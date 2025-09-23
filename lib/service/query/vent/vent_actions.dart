import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/service/query/vent/comment/comment_actions.dart';
import 'package:revent/shared/api/api_client.dart';
import 'package:revent/shared/api/api_path.dart';
import 'package:revent/shared/provider_mixins.dart';
import 'package:revent/main.dart';
import 'package:revent/service/query/general/base_query_service.dart';
import 'package:revent/service/current_provider_service.dart';
import 'package:revent/helper/format_date.dart';
import 'package:revent/shared/provider/vent/comments_provider.dart';

class VentActions extends BaseQueryService with 
  UserProfileProviderService, 
  CommentsProviderService, 
  VentProviderService {

  final int postId;

  VentActions({required this.postId});
// TODO: Try to create separate folder action/ to store each individual actions like; like/save/pin/delete
  Map<String, dynamic> _getVentProvider() {

    final currentProvider = CurrentProviderService(postId: postId).getProvider();

    return currentProvider;

  }

  Future<Map<String, dynamic>> likePost() async {

    final response = await ApiClient.post(ApiPath.likeVent, {
      'post_id': postId,
      'liked_by': userProvider.user.username,
    });

    if (response.statusCode == 200) {
      _updatePostLikeValue(isPostAlreadyLiked: response.body!['liked']);
    }

    return {
      'status_code': response.statusCode
    };

  }

  void _updatePostLikeValue({required bool isPostAlreadyLiked}) {

    final currentProvider = _getVentProvider();

    final index = currentProvider['vent_index'];
    final ventData = currentProvider['vent_data'];

    ventData.likeVent(index, isPostAlreadyLiked);

  }

  Future<Map<String, dynamic>> savePost() async {

    final response = await ApiClient.post(ApiPath.saveVent, {
      'post_id': postId,
      'saved_by': userProvider.user.username
    });

    if (response.statusCode == 200) {
      _updatePostSavedValue(isUserSavedPost: response.body!['saved']);
    }

    return {
      'status_code': response.statusCode
    };

  }

  void _updatePostSavedValue({required bool isUserSavedPost}) {

    final currentProvider = _getVentProvider();

    final index = currentProvider['vent_index'];
    final ventData = currentProvider['vent_data'];

    ventData.saveVent(index, isUserSavedPost);

  }
  
  Future<void> sendComment({required String comment}) async {

    await CommentActions(
      commentText: comment, 
      username: userProvider.user.username
    ).createCommentTransaction().then(
      (_) => _addComment(comment: comment)
    );

  }

  void _addComment({required String comment}) {

    final now = DateTime.now();
    final formattedTimestamp = FormatDate().formatPostTimestamp(now);

    final newComment = CommentsData(
      commentedBy: userProvider.user.username, 
      comment: comment,
      commentTimestamp: formattedTimestamp,
      pfpData: getIt.profileProvider.profile.profilePicture
    );

    commentsProvider.addComment(newComment);

  }

}