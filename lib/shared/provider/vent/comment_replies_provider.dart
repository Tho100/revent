import 'dart:typed_data';

import 'package:flutter/material.dart';
// TODO: Rename to ReplyData
class CommentRepliesData {

  String repliedBy;
  String reply;
  String replyTimestamp;

  int totalLikes;

  bool isReplyLiked;
  bool isReplyLikedByCreator;

  Uint8List pfpData;

  CommentRepliesData({
    required this.repliedBy,
    required this.reply,
    required this.replyTimestamp,
    required this.pfpData,
    this.totalLikes = 0,
    this.isReplyLiked = false,
    this.isReplyLikedByCreator = false
  });

}
// TODO: Rename to RepliesProvider
class CommentRepliesProvider extends ChangeNotifier {

  List<CommentRepliesData> _commentReplies = [];

  List<CommentRepliesData> get commentReplies => _commentReplies;

  void setReplies(List<CommentRepliesData> replies) {
    _commentReplies = replies;
    notifyListeners();
  }

  void addReply(CommentRepliesData reply) {
    _commentReplies.add(reply);
    notifyListeners();
  }

  void deleteReply(int index) {
    if (index >= 0 && index < _commentReplies.length) {
      _commentReplies.removeAt(index);
      notifyListeners();
    }
  }

  void editReply(String username, String newComment, String originalComment) {
    
    final index = _commentReplies.indexWhere(
      (comment) => comment.repliedBy == username && comment.reply == originalComment
    );

    _commentReplies[index].reply = newComment;

    notifyListeners();

  }

  void likeReply(int index, bool isUserLikedComment) {

    _commentReplies[index].isReplyLiked = isUserLikedComment 
      ? false
      : true;

    _commentReplies[index].isReplyLiked 
      ? _commentReplies[index].totalLikes += 1
      : _commentReplies[index].totalLikes -= 1;

    notifyListeners();
    
  }

  void deleteReplies() {
    _commentReplies.clear();
  }

}