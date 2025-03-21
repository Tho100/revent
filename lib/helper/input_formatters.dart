import 'package:flutter/services.dart';

class InputFormatters {

  List<TextInputFormatter> noSpaces() {
    return [FilteringTextInputFormatter.deny(RegExp(r'\s'))];
  }

  List<TextInputFormatter> onlyLetters() {
    return [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]'))];
  }

  List<TextInputFormatter> usernameFormatter() {
    return [
      ...noSpaces(), 
      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9._]'))
    ];
  }

}