import 'package:flutter/widgets.dart';

class GeneralSearchController {

  static final searchController = TextEditingController();

  static void dispose() {
    searchController.dispose();
  }

}