import 'package:flutter/material.dart';
import 'package:revent/shared/themes/theme_style.dart';

class BottomsheetOptionButton extends StatelessWidget {

  final String text;
  final IconData? icon; 
  final VoidCallback onPressed;

  const BottomsheetOptionButton({
    required this.text, 
    required this.onPressed,
    this.icon, 
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ThemeStyle.btnBottomsheetBgStyle,
      child: Row(
        children: [

          if (icon != null)
          Icon(icon, color: ThemeStyle.btnBottomsheetIconColor),

          SizedBox(width: icon != null ? 15 : 10),

          Text(
            text,
            style: ThemeStyle.btnBottomsheetTextStyle
          ),

        ],
      )
    );
  }

}