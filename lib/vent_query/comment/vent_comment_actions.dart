import 'package:get_it/get_it.dart';
import 'package:revent/connection/revent_connect.dart';
import 'package:revent/provider/vent_comment_provider.dart';

class VentCommentActions {

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

  final ventCommentProvider = GetIt.instance<VentCommentProvider>();

  Future<void> delete() async {

    final conn = await ReventConnect.initializeConnection();

    const query = 
      'DELETE FROM vent_comments_info WHERE commented_by = :commented_by AND comment = :comment AND title = :title AND creator = :creator';

    final params = {
      'commented_by': username,
      'comment': commentText,
      'title': ventTitle,
      'creator': ventCreator
    };

    await conn.execute(query, params);

    _removeComment();

  }

  void _removeComment() {

    final index = ventCommentProvider.ventComments
      .indexWhere((comment) => comment.commentedBy == username && comment.comment == commentText);

    if(index != -1) {
      ventCommentProvider.deleteComment(index);
    }

  }

}