import 'dart:typed_data';

import 'package:flutter/material.dart';

class VentComment {

  String commentedBy;
  String comment;
  String commentTimestamp;

  int totalLikes;

  bool isCommentLiked;
  bool isCommentLikedByCreator;

  Uint8List pfpData;

  VentComment({
    required this.commentedBy,
    required this.comment,
    required this.commentTimestamp,
    required this.pfpData,
    this.totalLikes = 0,
    this.isCommentLiked = false,
    this.isCommentLikedByCreator = false
  });

}

class VentCommentProvider extends ChangeNotifier {

  List<VentComment> _ventComments = [];

  List<VentComment> get ventComments => _ventComments;

  void setComments(List<VentComment> vents) {
    _ventComments = vents;
    notifyListeners();
  }

  void addComment(VentComment vent) {
    _ventComments.add(vent);
    notifyListeners();
  }

  void deleteComments() {
    _ventComments.clear();
    notifyListeners();
  }
  
  void deleteComment(int index) {
    if (index >= 0 && index < _ventComments.length) {
      _ventComments.removeAt(index);
      notifyListeners();
    }
  }

  void editComment(String username, String newComment, String originalComment) {
    
    final index = ventComments.indexWhere(
      (comment) => comment.commentedBy == username && comment.comment == originalComment
    );

    ventComments[index].comment = newComment;

    notifyListeners();

  }

  void likeComment(int index, bool isUserLikedComment) {

    _ventComments[index].isCommentLiked = isUserLikedComment 
      ? false
      : true;

    _ventComments[index].isCommentLiked 
      ? _ventComments[index].totalLikes += 1
      : _ventComments[index].totalLikes -= 1;

    notifyListeners();
    
  }

}