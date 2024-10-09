import 'package:flutter/material.dart';

class VentDataProvider extends ChangeNotifier {
  
  List<String> _ventTitles = <String>[];
  List<String> _ventBodyText = <String>[];
  List<String> _ventCreator = <String>[];
  List<String> _ventPostTimestamp = <String>[];

  List<int> _ventTotalLikes = <int>[];
  List<int> _ventTotalComments = <int>[];

  List<String> get ventTitles => _ventTitles;
  List<String> get ventBodyText => _ventBodyText;
  List<String> get ventCreator => _ventCreator;
  List<String> get ventPostTimestamp => _ventPostTimestamp;

  List<int> get ventTotalLikes => _ventTotalLikes;
  List<int> get ventTotalComments => _ventTotalComments;

  void setVentTitles(List<String> titles) {
    _ventTitles = titles;
    notifyListeners();
  }

  void setVentBodyText(List<String> bodyText) {
    _ventBodyText = bodyText;
    notifyListeners();
  }

  void setVentCreator(List<String> creator) {
    _ventCreator = creator;
    notifyListeners();
  }

  void setVentPostTimestamp(List<String> postTimestamp) {
    _ventPostTimestamp = postTimestamp;
    notifyListeners();
  }

  void setVentTotalLikes(List<int> creator) {
    _ventTotalLikes = creator;
    notifyListeners();
  }

  void setVentTotalComments(List<int> postTimestamp) {
    _ventTotalComments = postTimestamp;
    notifyListeners();
  }

  void addVentData(String title, String bodyText, String creator, String postTimestamp) {
    _ventTitles.add(title);
    _ventBodyText.add(bodyText);
    _ventCreator.add(creator);
    _ventPostTimestamp.add(postTimestamp);
    _ventTotalLikes.add(0);
    _ventTotalComments.add(0);
    notifyListeners();
  }

}