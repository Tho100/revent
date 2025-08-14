import 'package:flutter/widgets.dart';

mixin SecurityAuthController {

  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();

  void disposeControllers() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
  }

}