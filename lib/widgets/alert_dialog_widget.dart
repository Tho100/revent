import 'package:flutter/material.dart';
import 'package:revent/themes/theme_color.dart';

class AlertDialogWidget extends StatelessWidget {

  final Widget? title;
  final Widget? content;
  final List<Widget>? actions;

  const AlertDialogWidget({
    this.title,
    this.content,
    this.actions,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      backgroundColor: ThemeColor.black,
      title: title,
      content: content,
      actions: actions,
    );
  }

}