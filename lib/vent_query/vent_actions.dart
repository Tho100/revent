import 'package:get_it/get_it.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:revent/connection/revent_connect.dart';
import 'package:revent/helper/current_provider.dart';
import 'package:revent/model/extract_data.dart';
import 'package:revent/model/format_date.dart';
import 'package:revent/provider/navigation_provider.dart';
import 'package:revent/provider/profile_data_provider.dart';
import 'package:revent/provider/user_data_provider.dart';
import 'package:revent/provider/vent_comment_provider.dart';
import 'package:revent/provider/vent_data_provider.dart';
import 'package:revent/provider/vent_following_data_provider.dart';

class VentActions {

  final String title;
  final String creator;

  VentActions({
    required this.title,
    required this.creator,
  });

  final navigation = GetIt.instance<NavigationProvider>();

  final ventData = GetIt.instance<VentDataProvider>();
  final ventFollowingData = GetIt.instance<VentFollowingDataProvider>();

  final userData = GetIt.instance<UserDataProvider>();
  final profileData = GetIt.instance<ProfileDataProvider>();

  dynamic _getVentIndex() {

    final currentProvider = CurrentProvider(
      title: title, 
      creator: creator
    ).getProvider();

    return currentProvider;

  }

  Future<void> likePost() async {

    final conn = await ReventConnect.initializeConnection();

    const likesInfoParameterQuery = 'WHERE title = :title AND creator = :creator AND liked_by = :liked_by';

    final likesInfoParams = {
      'title': title,
      'creator': creator,
      'liked_by': userData.user.username,
    };

    final isUserLikedPost = await _isUserLikedPost(
      conn: conn,
      likesInfoParams: likesInfoParams,
      likesInfoParameterQuery: likesInfoParameterQuery
    );

    await _updateVentLikes(
      conn: conn, 
      isUserLikedPost: isUserLikedPost
    );

    await _updateLikesInfo(
      conn: conn,
      isUserLikedPost: isUserLikedPost,
      likesInfoParams: likesInfoParams,
      likesInfoParameterQuery: likesInfoParameterQuery
    );

    _updatePostLikeValue(
      isUserLikedPost: isUserLikedPost,
    );

  }

  Future<void> _updateVentLikes({
    required MySQLConnectionPool conn,
    required bool isUserLikedPost 
  }) async {

    final operationSymbol = isUserLikedPost ? '-' : '+';

    final updateLikeValueQuery = 
      'UPDATE vent_info SET total_likes = total_likes $operationSymbol 1 WHERE creator = :creator AND title = :title';

    final ventInfoParams = {
      'creator': creator,
      'title': title
    };

    await conn.execute(updateLikeValueQuery, ventInfoParams);

  }

  Future<bool> _isUserLikedPost({
    required MySQLConnectionPool conn,
    required Map<String, String> likesInfoParams,
    required String likesInfoParameterQuery  
  }) async {

    final readLikesInfoQuery = 
      'SELECT * FROM liked_vent_info $likesInfoParameterQuery';

    final likesInfoResults = await conn.execute(readLikesInfoQuery, likesInfoParams);

    return ExtractData(rowsData: likesInfoResults)
      .extractStringColumn('liked_by').isNotEmpty;

  }

  Future<void> _updateLikesInfo({
    required MySQLConnectionPool conn, 
    required bool isUserLikedPost,
    required Map<String, String> likesInfoParams,
    required String likesInfoParameterQuery,
  }) async {

    final query = isUserLikedPost 
      ? 'DELETE FROM liked_vent_info $likesInfoParameterQuery'
      : 'INSERT INTO liked_vent_info (title, creator, liked_by) VALUES (:title, :creator, :liked_by)';

    await conn.execute(query, likesInfoParams);

  }

  void _updatePostLikeValue({
    required bool isUserLikedPost,
  }) {

    final currentProvider = _getVentIndex();

    final index = currentProvider['vent_index'];
    final ventData = currentProvider['vent_data'];

    ventData.likeVent(index, isUserLikedPost);

  }

  Future<void> sendComment({
    required String comment
  }) async {

    final conn = await ReventConnect.initializeConnection();

    const insertCommentQuery = 
      'INSERT INTO vent_comments_info (title, creator, commented_by, comment, total_likes) VALUES (:title, :creator, :commented_by, :comment, :total_likes)'; 
      
    final commentsParams = {
      'title': title,
      'creator': creator,
      'commented_by': userData.user.username,
      'comment': comment,
      'total_likes': 0
    };

    await conn.execute(insertCommentQuery, commentsParams);

    await _updateTotalComments(
      conn: conn, 
      title: title, 
      creator: creator
    );

    _addComment(comment: comment);

  }

  Future<void> _updateTotalComments({
    required MySQLConnectionPool conn,
    required String title,
    required String creator 
  }) async {

    const updateTotalCommentsQuery = 
      'UPDATE vent_info SET total_comments = total_comments + 1 WHERE title = :title AND creator = :creator'; 
      
    final params = {
      'title': title,
      'creator': creator,
    };

    await conn.execute(updateTotalCommentsQuery, params);

  }

  void _addComment({
    required String comment
  }) {

    final ventCommentProvider = GetIt.instance<VentCommentProvider>();

    final now = DateTime.now();
    final formattedTimestamp = FormatDate().formatPostTimestamp(now);

    final newComment = VentComment(
      commentedBy: userData.user.username, 
      comment: comment,
      commentTimestamp: formattedTimestamp,
      pfpData: profileData.profilePicture
    );

    ventCommentProvider.addComment(newComment);

  }

  Future<void> savePost() async {

    final conn = await ReventConnect.initializeConnection();

    const savedInfoParamsQuery = 'WHERE title = :title AND creator = :creator AND saved_by = :saved_by';

    final savedInfoParams = {
      'title': title,
      'creator': creator,
      'saved_by': userData.user.username,
    };

    final isUserSavedPost = await _isUserSavedPost(
      conn: conn, 
      savedInfoParamsQuery: savedInfoParamsQuery, 
      savedInfoParams: savedInfoParams
    );

    await _updateSavedInfo(
      conn: conn, 
      isUserSavedPost: isUserSavedPost, 
      savedInfoParamsQuery: savedInfoParamsQuery, 
      savedInfoParams: savedInfoParams
    );

    _updatePostSavedValue(
      isUserSavedPost: isUserSavedPost
    );

  }

  Future<bool> _isUserSavedPost({
    required MySQLConnectionPool conn,
    required String savedInfoParamsQuery,
    required Map<String, String> savedInfoParams,
  }) async {

    final readSavedInfoQuery = 
      'SELECT * FROM saved_vent_info $savedInfoParamsQuery';

    final savedInfoResults = await conn.execute(readSavedInfoQuery, savedInfoParams);

    return ExtractData(rowsData: savedInfoResults)
      .extractStringColumn('saved_by').isNotEmpty;

  }

  Future<void> _updateSavedInfo({
    required MySQLConnectionPool conn, 
    required bool isUserSavedPost,
    required String savedInfoParamsQuery,
    required Map<String, String> savedInfoParams,
  }) async {

    final query = isUserSavedPost 
      ? 'DELETE FROM saved_vent_info $savedInfoParamsQuery'
      : 'INSERT INTO saved_vent_info (title, creator, saved_by) VALUES (:title, :creator, :saved_by)';

    await conn.execute(query, savedInfoParams);

  }

  void _updatePostSavedValue({
    required bool isUserSavedPost,
  }) {

    final currentProvider = _getVentIndex();

    final index = currentProvider['vent_index'];
    final ventData = currentProvider['vent_data'];

    ventData.saveVent(index, isUserSavedPost);

  }

}