import 'package:flutter/cupertino.dart';

class ActiveVentData {

  String title;
  String creator;
  String body;
  String? lastEdit;

  ActiveVentData({
    required this.title,
    required this.creator,
    required this.body,
    this.lastEdit = ''
  });

}

class ActiveVentProvider extends ChangeNotifier {

  ActiveVentData _ventData = ActiveVentData(title: '', creator: '', body: '', lastEdit: '');

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
      lastEdit: _ventData.lastEdit,
    );
    notifyListeners();
  }

  void setLastEdit(String lastEdit) {
    _ventData = ActiveVentData(
      title: _ventData.title,
      creator: _ventData.creator,
      body: _ventData.body,
      lastEdit: lastEdit,
    );
    notifyListeners();
  }

  void clearData() {
    _ventData.title = '';
    _ventData.creator = '';
    _ventData.body = '';
    _ventData.lastEdit = '';
  }

}