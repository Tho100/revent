import 'package:flutter/material.dart';

class InkWellEffect extends StatelessWidget {

  final VoidCallback onPressed;
  final VoidCallback? onLongPress;
  final Widget child;

  const InkWellEffect({
    required this.onPressed,
    required this.child,
    this.onLongPress,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onPressed,
        onLongPress: onLongPress,
        child: child,
      )
    );
  }

}