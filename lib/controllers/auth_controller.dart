import 'package:flutter/material.dart';

class AuthController {

  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

 void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

}