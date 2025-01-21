import 'dart:typed_data';

import 'package:flutter/cupertino.dart';

class ActiveVentData {

  String title;
  String creator;
  String body;
  Uint8List creatorPfp;
  String? lastEdit;

  ActiveVentData({
    required this.title,
    required this.creator,
    required this.body,
    required this.creatorPfp,
    this.lastEdit = ''
  });

}

class ActiveVentProvider extends ChangeNotifier {

  ActiveVentData _ventData = ActiveVentData(
    title: '', creator: '', body: '', creatorPfp: Uint8List(0), lastEdit: ''
  );

  ActiveVentData get ventData => _ventData;

  void setVentData(ActiveVentData ventData) {
    _ventData = ventData;
    notifyListeners();
  }

  void setBody(String body) {
    _ventData = ActiveVentData(
      title: _ventData.title,
      creator: _ventData.creator,
      body: body,
      creatorPfp: _ventData.creatorPfp,
      lastEdit: _ventData.lastEdit,
    );
    notifyListeners();
  }

  void setLastEdit(String lastEdit) {
    _ventData = ActiveVentData(
      title: _ventData.title,
      creator: _ventData.creator,
      body: _ventData.body,
      creatorPfp: _ventData.creatorPfp,
      lastEdit: lastEdit,
    );
    notifyListeners();
  }

  void clearData() {
    _ventData.title = '';
    _ventData.creator = '';
    _ventData.body = '';
    _ventData.lastEdit = '';
    _ventData.creatorPfp = Uint8List(0);
  }

}