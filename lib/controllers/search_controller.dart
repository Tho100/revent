import 'package:flutter/widgets.dart';

mixin GeneralSearchController {

  final searchController = TextEditingController();

  void disposeControllers() {
    searchController.dispose();
  }

}