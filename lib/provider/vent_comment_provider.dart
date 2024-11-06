import 'package:flutter/material.dart';

class VentComment {

  String commentedBy;
  String comment;

  VentComment({
    required this.commentedBy,
    required this.comment,
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
  
}