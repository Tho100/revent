import 'package:flutter/material.dart';
import 'package:revent/shared/themes/theme_color.dart';

class Bottomsheet {

  Future buildBottomSheet({
    required BuildContext context,
    required List<Widget> children
  }) {
    return showModalBottomSheet(
      backgroundColor: ThemeColor.black,
      shape: const RoundedRectangleBorder( 
        side: BorderSide(
          color: ThemeColor.lightGrey,
          width: 1
        ),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25)
        ),
      ),
      isScrollControlled: true,
      context: context, 
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: children,
          ),
        );
      }
    );
  }

}