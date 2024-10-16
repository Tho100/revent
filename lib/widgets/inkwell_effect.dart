import 'package:flutter/material.dart';

class InkWellEffect extends StatelessWidget {

  final VoidCallback onPressed;
  final Widget child;

  const InkWellEffect({
    required this.onPressed,
    required this.child,
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
        child: child,
      )
    );
  }

}