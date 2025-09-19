import 'package:revent/global/table_names.dart';
import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/service/query/vent/comment/comment_actions.dart';
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

  Map<String, dynamic> _getVentProvider() {

    final currentProvider = CurrentProviderService(postId: postId).getProvider();

    return currentProvider;

  }

  Future<void> likePost() async {

    const likesInfoQueryParams = 'WHERE post_id = :post_id AND liked_by = :liked_by';

    final likesInfoParams = {
      'post_id': postId,
      'liked_by': userProvider.user.username,
    };

    final isPostAlreadyLiked = await _isUserLikedPost(
      likesInfoParams: likesInfoParams,
      likesInfoQueryParams: likesInfoQueryParams
    );

    final conn = await connection();

    await conn.transactional((txn) async {

      await txn.execute(
        '''
          UPDATE ${TableNames.ventInfo} 
          SET total_likes = total_likes ${isPostAlreadyLiked ? '-' : '+'} 1 
          WHERE post_id = :post_id
        ''',
        {'post_id': postId}
      );

      await txn.execute(
        isPostAlreadyLiked 
          ? 'DELETE FROM ${TableNames.likedVentInfo} $likesInfoQueryParams'
          : 'INSERT INTO ${TableNames.likedVentInfo} (post_id, liked_by) VALUES (:post_id, :liked_by)',
        likesInfoParams
      );

    }).then(
      (_) => _updatePostLikeValue(isPostAlreadyLiked: isPostAlreadyLiked)
    );

  }

  Future<bool> _isUserLikedPost({
    required Map<String, dynamic> likesInfoParams,
    required String likesInfoQueryParams
  }) async {

    final getLikesInfoQuery = 
      'SELECT 1 FROM ${TableNames.likedVentInfo} $likesInfoQueryParams';

    final likesInfoResults = await executeQuery(getLikesInfoQuery, likesInfoParams);

    return likesInfoResults.rows.isNotEmpty;

  }

  void _updatePostLikeValue({required bool isPostAlreadyLiked}) {

    final currentProvider = _getVentProvider();

    final index = currentProvider['vent_index'];
    final ventData = currentProvider['vent_data'];

    ventData.likeVent(index, isPostAlreadyLiked);

  }

  Future<void> savePost() async {

    const savedInfoQueryParams = 'WHERE post_id = :post_id AND saved_by = :saved_by';

    final savedInfoParams = {
      'post_id': postId,
      'saved_by': userProvider.user.username
    };

    final isUserSavedPost = await _isUserSavedPost(
      savedInfoQueryParams: savedInfoQueryParams, 
      savedInfoParams: savedInfoParams
    );

    await _updatePostSavedInfo(
      isUserSavedPost: isUserSavedPost, 
      savedInfoQueryParams: savedInfoQueryParams, 
      savedInfoParams: savedInfoParams
    );

    _updatePostSavedValue(isUserSavedPost: isUserSavedPost);

  }

  Future<bool> _isUserSavedPost({
    required String savedInfoQueryParams,
    required Map<String, dynamic> savedInfoParams
  }) async {

    final getSavedInfoQuery = 
      'SELECT 1 FROM ${TableNames.savedVentInfo} $savedInfoQueryParams'; 

    final savedInfoResults = await executeQuery(getSavedInfoQuery, savedInfoParams);
    
    return savedInfoResults.rows.isNotEmpty;

  }

  Future<void> _updatePostSavedInfo({
    required bool isUserSavedPost,
    required String savedInfoQueryParams,
    required Map<String, dynamic> savedInfoParams,
  }) async {

    final query = isUserSavedPost 
      ? 'DELETE FROM ${TableNames.savedVentInfo} $savedInfoQueryParams'
      : 'INSERT INTO ${TableNames.savedVentInfo} (post_id, saved_by) VALUES (:post_id, :saved_by)';

    await executeQuery(query, savedInfoParams);

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