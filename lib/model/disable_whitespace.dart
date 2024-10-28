import 'package:flutter/services.dart';

class DisableWhitespaceTextField {

  List<TextInputFormatter>? disable() {
    return [FilteringTextInputFormatter.deny(RegExp(r'\s'))];
  }

}