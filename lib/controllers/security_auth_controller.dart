import 'package:flutter/material.dart';

class SecurityAuthController {

  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();

  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
  }

}