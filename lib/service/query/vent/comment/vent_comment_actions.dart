import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/main.dart';
import 'package:revent/service/query/general/base_query_service.dart';
import 'package:revent/helper/extract_data.dart';

class VentCommentActions extends BaseQueryService {

  final String username;
  final String commentText;
  final String ventCreator;
  final String ventTitle;

  VentCommentActions({
    required this.username,
    required this.commentText,
    required this.ventCreator,
    required this.ventTitle
  });

  final ventCommentProvider = getIt.ventCommentProvider;

  Future<void> delete() async {

    const query = 
      'DELETE FROM vent_comments_info WHERE commented_by = :commented_by AND comment = :comment AND title = :title AND creator = :creator';

    final params = {
      'commented_by': username,
      'comment': commentText,
      'title': ventTitle,
      'creator': ventCreator
    };

    await executeQuery(query, params).then(
      (_) => _removeComment()
    );

  }

  void _removeComment() {

    final index = ventCommentProvider.ventComments
      .indexWhere((comment) => comment.commentedBy == username && comment.comment == commentText);

    if(index != -1) {
      ventCommentProvider.deleteComment(index);
    }

  }

  Future<void> like() async {

    const likesInfoParameterQuery = 
      'WHERE title = :title AND creator = :creator AND liked_by = :liked_by AND commented_by = :commented_by AND comment = :comment';

    final likesInfoParams = {
      'title': ventTitle,
      'creator': ventCreator,
      'liked_by': getIt.userProvider.user.username,
      'commented_by': username,
      'comment': commentText
    };

    final isUserLikedComment = await _isUserLikedComment(
      likesInfoParams: likesInfoParams,
      likesInfoParameterQuery: likesInfoParameterQuery
    );

    await _updateCommentLikes(isUserLikedPost: isUserLikedComment);

    await _updateLikesInfo(
      isUserLikedPost: isUserLikedComment,
      likesInfoParams: likesInfoParams,
      likesInfoParameterQuery: likesInfoParameterQuery
    );

    final index = ventCommentProvider.ventComments.indexWhere(
      (comment) => comment.commentedBy == username && comment.comment == commentText
    );

    _updateCommentLikedValue(
      index: index,
      isUserLikedComment: isUserLikedComment,
    );

  }

  Future<void> _updateCommentLikes({
    required bool isUserLikedPost 
  }) async {

    final operationSymbol = isUserLikedPost ? '-' : '+';

    final updateLikeValueQuery = 
      'UPDATE vent_comments_info SET total_likes = total_likes $operationSymbol 1 WHERE creator = :creator AND title = :title AND commented_by = :commented_by AND comment = :comment';

    final ventInfoParams = {
      'creator': ventCreator,
      'title': ventTitle,
      'commented_by': username,
      'comment': commentText
    };

    await executeQuery(updateLikeValueQuery, ventInfoParams);

  }

  Future<bool> _isUserLikedComment({
    required Map<String, String> likesInfoParams,
    required String likesInfoParameterQuery  
  }) async {

    final readLikesInfoQuery = 
      'SELECT * FROM vent_comments_likes_info $likesInfoParameterQuery';

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
      ? 'DELETE FROM vent_comments_likes_info $likesInfoParameterQuery'
      : 'INSERT INTO vent_comments_likes_info (title, creator, liked_by, commented_by, comment) VALUES (:title, :creator, :liked_by, :commented_by, :comment)';

    await executeQuery(query, likesInfoParams);

  }

  void _updateCommentLikedValue({
    required int index,
    required bool isUserLikedComment,
  }) {

    if(index != -1) {
      ventCommentProvider.likeComment(index, isUserLikedComment);
    }

  }

}