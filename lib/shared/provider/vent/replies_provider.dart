import 'dart:typed_data';

import 'package:flutter/material.dart';

class ReplyData {

  String repliedBy;
  String reply;
  String replyTimestamp;

  int totalLikes;

  bool isReplyLiked;
  bool isReplyLikedByCreator;

  Uint8List pfpData;

  ReplyData({
    required this.repliedBy,
    required this.reply,
    required this.replyTimestamp,
    required this.pfpData,
    this.totalLikes = 0,
    this.isReplyLiked = false,
    this.isReplyLikedByCreator = false
  });

}

class RepliesProvider extends ChangeNotifier {

  List<ReplyData> _replies = [];

  List<ReplyData> get replies => _replies;

  void setReplies(List<ReplyData> replies) {
    _replies = replies;
    notifyListeners();
  }

  void addReply(ReplyData reply) {
    _replies.add(reply);
    notifyListeners();
  }

  void deleteReply(int index) {
    if (index >= 0 && index < _replies.length) {
      _replies.removeAt(index);
      notifyListeners();
    }
  }

  void editReply(String username, String newReply, String originalReply) {
    
    final index = _replies.indexWhere(
      (comment) => comment.repliedBy == username && comment.reply == originalReply
    );

    _replies[index].reply = newReply;

    notifyListeners();

  }

  void likeReply(int index, bool isUserLikedReply) {

    _replies[index].isReplyLiked = isUserLikedReply 
      ? false
      : true;

    _replies[index].isReplyLiked 
      ? _replies[index].totalLikes += 1
      : _replies[index].totalLikes -= 1;

    notifyListeners();
    
  }

  void deleteReplies() {
    _replies.clear();
  }

}