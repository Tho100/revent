import 'package:flutter/material.dart';

class VentPostController {

  final titleController = TextEditingController();
  final bodyTextController = TextEditingController();

  void dispose() {
    titleController.dispose();
    bodyTextController.dispose();
  }

}