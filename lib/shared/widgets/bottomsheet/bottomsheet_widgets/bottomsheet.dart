import 'package:flutter/material.dart';
import 'package:revent/shared/themes/theme_color.dart';

class Bottomsheet {

  Future buildBottomSheet({
    required BuildContext context,
    required List<Widget> children
  }) {
    return showModalBottomSheet(
      barrierColor: ThemeColor.barrier,
      backgroundColor: ThemeColor.backgroundPrimary,
      shape: const RoundedRectangleBorder( 
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25)
        ),
      ),
      isScrollControlled: true,
      context: context,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: children,
          ),
        ),
      ),
    );
  }

}