import 'dart:typed_data';

import 'package:flutter/material.dart';

class VentComment {

  String commentedBy;
  String comment;
  String commentTimestamp;
  Uint8List pfpData;

  VentComment({
    required this.commentedBy,
    required this.comment,
    required this.commentTimestamp,
    required this.pfpData
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

}