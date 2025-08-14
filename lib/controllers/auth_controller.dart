import 'package:flutter/widgets.dart';

mixin AuthController {

  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void disposeControllers() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

}