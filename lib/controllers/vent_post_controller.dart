import 'package:flutter/widgets.dart';

mixin VentPostController {

  final titleController = TextEditingController();
  final bodyTextController = TextEditingController();

  void disposeControllers() {
    titleController.dispose();
    bodyTextController.dispose();
  }

}