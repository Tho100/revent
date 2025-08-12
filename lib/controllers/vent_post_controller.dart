import 'package:flutter/material.dart';

class VentPostController {

  static final titleController = TextEditingController();
  static final bodyTextController = TextEditingController();

  static void dispose() {
    titleController.dispose();
    bodyTextController.dispose();
  }

}