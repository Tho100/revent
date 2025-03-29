import 'package:flutter/material.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/themes/theme_style.dart';

class Bottomsheet {

  Future buildBottomSheet({
    required BuildContext context,
    required List<Widget> children
  }) {
    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (_) {
        return Container(
          decoration: const BoxDecoration(
            color: ThemeColor.black,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(25),
            ),
            border: Border(
              top: ThemeStyle.dialogSideBorder
            ),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: children,
          ),
        );
      },
    );
  }

}