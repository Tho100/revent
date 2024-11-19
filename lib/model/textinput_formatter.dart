import 'package:flutter/services.dart';

class TextInputFormatterModel {

  List<TextInputFormatter>? disableWhitespaces() {
    return [FilteringTextInputFormatter.deny(RegExp(r'\s'))];
  }

  List<TextInputFormatter>? disableWhitespacesAndSymbols() {
    return [
      FilteringTextInputFormatter.deny(RegExp(r'\s')), 
      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]'))
    ];
  }

}