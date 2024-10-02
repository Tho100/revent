import 'package:flutter/material.dart';
import 'package:revent/themes/theme_color.dart';
import 'package:revent/themes/theme_style.dart';

class Bottomsheet {

  Future buildBottomSheet({
    required BuildContext context,
    required List<Widget> children
  }) {
    return showModalBottomSheet(
      backgroundColor: ThemeColor.black,
      shape: ThemeStyle.bottomDialogBorderStyle,
      isScrollControlled: true,
      context: context, 
      builder: (context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: children
        );
      }
    );
  }

}