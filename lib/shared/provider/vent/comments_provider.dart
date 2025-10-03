import 'dart:typed_data';

import 'package:flutter/material.dart';

class CommentsData {

  String commentedBy;
  String comment;
  String commentTimestamp;

  int totalLikes;
  int totalReplies;

  bool isCommentLiked;
  bool isCommentLikedByCreator;
  bool isPinned;
  bool isEdited;

  Uint8List pfpData;

  CommentsData({
    required this.commentedBy,
    required this.comment,
    required this.commentTimestamp,
    required this.pfpData,
    this.totalLikes = 0,
    this.totalReplies = 0,
    this.isCommentLiked = false,
    this.isCommentLikedByCreator = false,
    this.isPinned = false,
    this.isEdited = false
  });

}

class CommentsProvider extends ChangeNotifier {

  List<CommentsData> _comments = [];

  List<CommentsData> get comments => _comments;

  void setComments(List<CommentsData> comments) {
    _comments = comments;
    notifyListeners();
  }

  void addComment(CommentsData comment) {
    _comments.add(comment);
    notifyListeners();
  }

  void deleteComment(int index) {
    if (index >= 0 && index < _comments.length) {
      _comments.removeAt(index);
      notifyListeners();
    }
  }

  void editComment(String username, String newComment, String originalComment) {
    
    final index = comments.indexWhere(
      (comment) => comment.commentedBy == username && comment.comment == originalComment
    );

    comments[index].comment = newComment;

    notifyListeners();

  }

  void pinComment(bool pin, int index) {

    if (index >= 0 && index < _comments.length) {

      _comments[index].isPinned = pin;

      _comments.sort((a, b) {
        if (a.isPinned && !b.isPinned) return -1;
        if (!a.isPinned && b.isPinned) return 1;
        return 0;
      });

      notifyListeners();

    }

  }

  void likeComment(int index, bool isUserLikedComment) {
// TODO: Simplify logic
    _comments[index].isCommentLiked = isUserLikedComment 
      ? false
      : true;

    _comments[index].isCommentLiked 
      ? _comments[index].totalLikes += 1
      : _comments[index].totalLikes -= 1;

    notifyListeners();
    
  }

  void deleteComments() {
    _comments.clear();
  }

}