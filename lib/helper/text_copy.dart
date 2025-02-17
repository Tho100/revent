import 'package:flutter/services.dart';

class TextCopy {

  final String text;

  TextCopy({required this.text});

  Future<void> copy() async {

    await Clipboard.setData(
      ClipboardData(text: text)
    );
    
  }

}