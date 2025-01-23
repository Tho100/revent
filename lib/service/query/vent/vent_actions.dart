import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/main.dart';
import 'package:revent/service/query/general/base_query_service.dart';
import 'package:revent/service/current_provider_service.dart';
import 'package:revent/helper/format_date.dart';
import 'package:revent/service/query/general/post_id_getter.dart';
import 'package:revent/shared/provider/vent/vent_comment_provider.dart';

class VentActions extends BaseQueryService {

  final String title;
  final String creator;

  VentActions({
    required this.title,
    required this.creator
  });

  final userData = getIt.userProvider.user;

  Map<String, dynamic> _getVentProvider() {

    final currentProvider = CurrentProviderService(
      title: title, 
      creator: creator
    ).getProvider();

    return currentProvider;

  }

  Future<void> likePost() async {

    final postId = await PostIdGetter(title: title, creator: creator).getPostId();

    const likesInfoParameterQuery = 'WHERE post_id = :post_id AND liked_by = :liked_by';

    final likesInfoParams = {
      'post_id': postId,
      'liked_by': userData.username,
    };

    final isUserLikedPost = await _isUserLikedPost(
      likesInfoParams: likesInfoParams,
      likesInfoParameterQuery: likesInfoParameterQuery
    );

    await _updateVentLikes(
      postId: postId, 
      isUserLikedPost: isUserLikedPost
    );

    await _updateLikesInfo(
      isUserLikedPost: isUserLikedPost,
      likesInfoParams: likesInfoParams,
      likesInfoParameterQuery: likesInfoParameterQuery
    );

    _updatePostLikeValue(isUserLikedPost: isUserLikedPost);

  }

  Future<void> _updateVentLikes({
    required int postId,
    required bool isUserLikedPost
  }) async {

    final operationSymbol = isUserLikedPost ? '-' : '+';

    final updateLikeValueQuery = 
    '''
      UPDATE vent_info 
      SET total_likes = total_likes $operationSymbol 1 
      WHERE post_id = :post_id
    ''';

    final param = {'post_id': postId};

    await executeQuery(updateLikeValueQuery, param);

  }

  Future<bool> _isUserLikedPost({
    required Map<String, dynamic> likesInfoParams,
    required String likesInfoParameterQuery  
  }) async {

    final readLikesInfoQuery = 
      'SELECT 1 FROM liked_vent_info $likesInfoParameterQuery';

    final likesInfoResults = await executeQuery(readLikesInfoQuery, likesInfoParams);

    return likesInfoResults.rows.isNotEmpty;

  }

  Future<void> _updateLikesInfo({
    required bool isUserLikedPost,
    required Map<String, dynamic> likesInfoParams,
    required String likesInfoParameterQuery,
  }) async {

    final query = isUserLikedPost 
      ? 'DELETE FROM liked_vent_info $likesInfoParameterQuery'
      : 'INSERT INTO liked_vent_info (post_id, liked_by) VALUES (:post_id, :liked_by)';

    await executeQuery(query, likesInfoParams);

  }

  void _updatePostLikeValue({required bool isUserLikedPost}) {

    final currentProvider = _getVentProvider();

    final index = currentProvider['vent_index'];
    final ventData = currentProvider['vent_data'];

    ventData.likeVent(index, isUserLikedPost);

  }

  Future<void> sendComment({required String comment}) async {

    final postId = await PostIdGetter(title: title, creator: creator).getPostId();

    const insertCommentQuery = 
      'INSERT INTO comments_info (commented_by, comment, total_likes, total_replies, post_id) VALUES (:commented_by, :comment, :total_likes, :total_replies, :post_id)'; 
      
    final commentsParams = {
      'commented_by': userData.username,
      'comment': comment,
      'total_likes': 0,
      'total_replies': 0,
      'post_id': postId
    };

    await executeQuery(insertCommentQuery, commentsParams).then(
      (_) async => await _updateTotalComments(postId: postId)
    );

    _addComment(comment: comment);

  }

  Future<void> _updateTotalComments({required int postId}) async {

    const updateTotalCommentsQuery = 
      'UPDATE vent_info SET total_comments = total_comments + 1 WHERE post_id = :post_id'; 
      
    final param = {'post_id': postId};

    await executeQuery(updateTotalCommentsQuery, param);

  }

  void _addComment({required String comment}) {

    final now = DateTime.now();
    final formattedTimestamp = FormatDate().formatPostTimestamp(now);

    final newComment = VentCommentData(
      commentedBy: userData.username, 
      comment: comment,
      commentTimestamp: formattedTimestamp,
      pfpData: getIt.profileProvider.profile.profilePicture
    );

    getIt.ventCommentProvider.addComment(newComment);

  }

  Future<void> savePost() async {

    final postId = await PostIdGetter(title: title, creator: creator).getPostId();

    const savedInfoParamsQuery = 'WHERE post_id = :post_id AND saved_by = :saved_by';

    final savedInfoParams = {
      'post_id': postId,
      'saved_by': userData.username
    };

    final isUserSavedPost = await _isUserSavedPost(
      savedInfoParamsQuery: savedInfoParamsQuery, 
      savedInfoParams: savedInfoParams
    );

    await _updateSavedInfo(
      isUserSavedPost: isUserSavedPost, 
      savedInfoParamsQuery: savedInfoParamsQuery, 
      savedInfoParams: savedInfoParams
    );

    _updatePostSavedValue(isUserSavedPost: isUserSavedPost);

  }

  Future<bool> _isUserSavedPost({
    required String savedInfoParamsQuery,
    required Map<String, dynamic> savedInfoParams,
  }) async {

    final readSavedInfoQuery = 
      'SELECT 1 FROM saved_vent_info $savedInfoParamsQuery'; 

    final savedInfoResults = await executeQuery(readSavedInfoQuery, savedInfoParams);
    
    return savedInfoResults.rows.isNotEmpty;

  }

  Future<void> _updateSavedInfo({
    required bool isUserSavedPost,
    required String savedInfoParamsQuery,
    required Map<String, dynamic> savedInfoParams,
  }) async {

    final query = isUserSavedPost 
      ? 'DELETE FROM saved_vent_info $savedInfoParamsQuery'
      : 'INSERT INTO saved_vent_info (post_id, saved_by) VALUES (:post_id, :saved_by)';

    await executeQuery(query, savedInfoParams);

  }

  void _updatePostSavedValue({required bool isUserSavedPost}) {

    final currentProvider = _getVentProvider();

    final index = currentProvider['vent_index'];
    final ventData = currentProvider['vent_data'];

    ventData.saveVent(index, isUserSavedPost);

  }

}