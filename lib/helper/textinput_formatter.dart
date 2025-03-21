import 'package:flutter/services.dart';

class TextInputFormatterModel {

  List<TextInputFormatter> disableWhitespaces() {
    return [FilteringTextInputFormatter.deny(RegExp(r'\s'))];
  }

  List<TextInputFormatter> onlyAllowLetters() {
    return [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]'))];
  }

  List<TextInputFormatter> usernameFormatter() {
    return [
      ...TextInputFormatterModel().disableWhitespaces(), 
      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9._]'))
    ];
  }

  bool isValidUsernameFormat(String username) {
    return RegExp(r'^(?!.*\.\.)(?!^\.)[a-zA-Z0-9._]+(?<!\.)$').hasMatch(username);
  }

}