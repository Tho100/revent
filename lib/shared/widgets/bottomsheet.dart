import 'package:flutter/material.dart';
import 'package:revent/shared/themes/theme_color.dart';

class Bottomsheet {

  Future buildBottomSheet({
    required BuildContext context,
    required List<Widget> children
  }) {
    return showModalBottomSheet(
      backgroundColor: ThemeColor.mediumBlack,
      shape: const RoundedRectangleBorder( 
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(18),
        ),
      ),
      isScrollControlled: true,
      context: context, 
      builder: (_) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: children
        );
      }
    );
  }

}