import 'package:flutter/services.dart';

class InputFormatters {

  static List<TextInputFormatter> noSpaces() {
    return [FilteringTextInputFormatter.deny(RegExp(r'\s'))];
  }

  static List<TextInputFormatter> onlyLetters() {
    return [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]'))];
  }

  static List<TextInputFormatter> usernameFormatter() {
    return [
      ...noSpaces(), 
      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9._]'))
    ];
  }

}