import 'package:flutter/widgets.dart';

class SecurityAuthController {

  static final currentPasswordController = TextEditingController();
  static final newPasswordController = TextEditingController();

  static void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
  }

}