import 'package:flutter/services.dart';
import 'package:revent/shared/widgets/ui_dialog/snack_bar.dart';

class TextCopy {

  final String text;

  TextCopy({required this.text});

  void copy() async {

    await Clipboard.setData(
      ClipboardData(text: text)
    );
    
    SnackBarDialog.temporarySnack(message: 'Copied text.');

  }

}