import 'package:flutter/material.dart';

class VentTextController {

  final titleController = TextEditingController();
  final bodyTextController = TextEditingController();

  void dispose() {
    titleController.dispose();
    bodyTextController.dispose();
  }

}