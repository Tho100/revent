import 'package:flutter/services.dart';

class TextInputFormatterModel {

  List<TextInputFormatter>? disableWhitespaces() {
    return [FilteringTextInputFormatter.deny(RegExp(r'\s'))];
  }

  List<TextInputFormatter>? onlyAllowLettersAndNumbers() {
    return [
      ...TextInputFormatterModel().disableWhitespaces()!, 
      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]'))
    ];
  }

  List<TextInputFormatter>? onlyAllowLetters() {
    return [
      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
    ];
  }

}