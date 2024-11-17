import 'package:get_it/get_it.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:revent/connection/revent_connect.dart';
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

  Future<void> likePost() async {

    final conn = await ReventConnect.initializeConnection();

    final index = navigation.activeTabIndex == 0
      ? ventData.vents.indexWhere(
        (vent) => vent.title == title && vent.creator == creator
      )
      : ventFollowingData.vents.indexWhere(
      (vent) => vent.title == title && vent.creator == creator
    );

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
      index: index,
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
      'SELECT * FROM vent_likes_info $likesInfoParameterQuery';

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
      ? 'DELETE FROM vent_likes_info $likesInfoParameterQuery'
      : 'INSERT INTO vent_likes_info (title, creator, liked_by) VALUES (:title, :creator, :liked_by)';

    await conn.execute(query, likesInfoParams);

  }

  void _updatePostLikeValue({
    required int index,
    required bool isUserLikedPost,
  }) {

    if(navigation.activeTabIndex == 0) {
      if(index != -1) {
        ventData.likeVent(index, isUserLikedPost);
      }

    } else if (navigation.activeTabIndex == 1) {
      if(index != -1) {
        ventFollowingData.likeVent(index, isUserLikedPost);
      }

    }

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

  Future<void> savePost() async {}

}