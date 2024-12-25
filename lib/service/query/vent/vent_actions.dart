import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/main.dart';
import 'package:revent/service/query/general/base_query_service.dart';
import 'package:revent/helper/current_provider.dart';
import 'package:revent/helper/extract_data.dart';
import 'package:revent/helper/format_date.dart';
import 'package:revent/shared/provider/vent/vent_comment_provider.dart';

class VentActions extends BaseQueryService {

  final String title;
  final String creator;

  VentActions({
    required this.title,
    required this.creator,
  });

  final userData = getIt.userProvider;

  Map<String, dynamic> _getVentProvider() {

    final currentProvider = CurrentProvider(
      title: title, 
      creator: creator
    ).getProvider();

    return currentProvider;

  }

  Future<void> likePost() async {

    const likesInfoParameterQuery = 
      'WHERE title = :title AND creator = :creator AND liked_by = :liked_by';

    final likesInfoParams = {
      'title': title,
      'creator': creator,
      'liked_by': userData.user.username,
    };

    final isUserLikedPost = await _isUserLikedPost(
      likesInfoParams: likesInfoParams,
      likesInfoParameterQuery: likesInfoParameterQuery
    );

    await _updateVentLikes(isUserLikedPost: isUserLikedPost);

    await _updateLikesInfo(
      isUserLikedPost: isUserLikedPost,
      likesInfoParams: likesInfoParams,
      likesInfoParameterQuery: likesInfoParameterQuery
    );

    _updatePostLikeValue(isUserLikedPost: isUserLikedPost);

  }

  Future<void> _updateVentLikes({required bool isUserLikedPost}) async {

    final operationSymbol = isUserLikedPost ? '-' : '+';

    final updateLikeValueQuery = 
      'UPDATE vent_info SET total_likes = total_likes $operationSymbol 1 WHERE creator = :creator AND title = :title';

    final ventInfoParams = {
      'creator': creator,
      'title': title
    };

    await executeQuery(updateLikeValueQuery, ventInfoParams);

  }

  Future<bool> _isUserLikedPost({
    required Map<String, String> likesInfoParams,
    required String likesInfoParameterQuery  
  }) async {

    final readLikesInfoQuery = 
      'SELECT * FROM liked_vent_info $likesInfoParameterQuery';

    final likesInfoResults = await executeQuery(readLikesInfoQuery, likesInfoParams);

    return ExtractData(rowsData: likesInfoResults)
      .extractStringColumn('liked_by').isNotEmpty;

  }

  Future<void> _updateLikesInfo({
    required bool isUserLikedPost,
    required Map<String, String> likesInfoParams,
    required String likesInfoParameterQuery,
  }) async {

    final query = isUserLikedPost 
      ? 'DELETE FROM liked_vent_info $likesInfoParameterQuery'
      : 'INSERT INTO liked_vent_info (title, creator, liked_by) VALUES (:title, :creator, :liked_by)';

    await executeQuery(query, likesInfoParams);

  }

  void _updatePostLikeValue({required bool isUserLikedPost}) {

    final currentProvider = _getVentProvider();

    final index = currentProvider['vent_index'];
    final ventData = currentProvider['vent_data'];

    ventData.likeVent(index, isUserLikedPost);

  }

  Future<void> sendComment({required String comment}) async {

    const insertCommentQuery = 
      'INSERT INTO vent_comments_info (title, creator, commented_by, comment, total_likes) VALUES (:title, :creator, :commented_by, :comment, :total_likes)'; 
      
    final commentsParams = {
      'title': title,
      'creator': creator,
      'commented_by': userData.user.username,
      'comment': comment,
      'total_likes': 0
    };

    await executeQuery(insertCommentQuery, commentsParams);

    await _updateTotalComments(
      title: title, 
      creator: creator
    );

    _addComment(comment: comment);

  }

  Future<void> _updateTotalComments({
    required String title,
    required String creator 
  }) async {

    const updateTotalCommentsQuery = 
      'UPDATE vent_info SET total_comments = total_comments + 1 WHERE title = :title AND creator = :creator'; 
      
    final params = {
      'title': title,
      'creator': creator,
    };

    await executeQuery(updateTotalCommentsQuery, params);

  }

  void _addComment({required String comment}) {

    final ventCommentProvider = getIt.ventCommentProvider;

    final now = DateTime.now();
    final formattedTimestamp = FormatDate().formatPostTimestamp(now);

    final newComment = VentCommentData(
      commentedBy: userData.user.username, 
      comment: comment,
      commentTimestamp: formattedTimestamp,
      pfpData: getIt.profileProvider.profile.profilePicture
    );

    ventCommentProvider.addComment(newComment);

  }

  Future<void> savePost() async {

    const savedInfoParamsQuery = 'WHERE title = :title AND creator = :creator AND saved_by = :saved_by';

    final savedInfoParams = {
      'title': title,
      'creator': creator,
      'saved_by': userData.user.username,
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
    required Map<String, String> savedInfoParams,
  }) async {

    final readSavedInfoQuery = 
      'SELECT * FROM saved_vent_info $savedInfoParamsQuery';

    final savedInfoResults = await executeQuery(readSavedInfoQuery, savedInfoParams);

    return ExtractData(rowsData: savedInfoResults)
      .extractStringColumn('saved_by').isNotEmpty;

  }

  Future<void> _updateSavedInfo({
    required bool isUserSavedPost,
    required String savedInfoParamsQuery,
    required Map<String, String> savedInfoParams,
  }) async {

    final query = isUserSavedPost 
      ? 'DELETE FROM saved_vent_info $savedInfoParamsQuery'
      : 'INSERT INTO saved_vent_info (title, creator, saved_by) VALUES (:title, :creator, :saved_by)';

    await executeQuery(query, savedInfoParams);

  }

  void _updatePostSavedValue({required bool isUserSavedPost}) {

    final currentProvider = _getVentProvider();

    final index = currentProvider['vent_index'];
    final ventData = currentProvider['vent_data'];

    ventData.saveVent(index, isUserSavedPost);

  }

}