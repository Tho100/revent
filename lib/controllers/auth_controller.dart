import 'package:flutter/material.dart'; // TODO: Import widgets instead

class AuthController {

  static final usernameController = TextEditingController();
  static final emailController = TextEditingController();
  static final passwordController = TextEditingController();

  static void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

}