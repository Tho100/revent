import 'package:flutter/material.dart';
import 'package:revent/shared/themes/theme_color.dart';

class BorderedContainer extends StatelessWidget {

  final Widget child;
  final bool? doubleInternalPadding;

  const BorderedContainer({
    required this.child, 
    this.doubleInternalPadding = false,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(
            color: ThemeColor.lightGrey,
            width: 0.8
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: doubleInternalPadding! ? 16 : 8),
          child: child,
        ),
      ),
    );
  }

}