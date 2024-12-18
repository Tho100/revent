import 'dart:typed_data';

import 'package:flutter/material.dart';

class VentCommentData {

  String commentedBy;
  String comment;
  String commentTimestamp;

  int totalLikes;

  bool isCommentLiked;
  bool isCommentLikedByCreator;

  Uint8List pfpData;

  VentCommentData({
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

  List<VentCommentData> _ventComments = [];

  List<VentCommentData> get ventComments => _ventComments;

  void setComments(List<VentCommentData> vents) {
    _ventComments = vents;
    notifyListeners();
  }

  void addComment(VentCommentData vent) {
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