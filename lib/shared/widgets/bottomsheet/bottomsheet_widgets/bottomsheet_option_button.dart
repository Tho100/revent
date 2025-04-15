import 'package:flutter/material.dart';
import 'package:revent/shared/themes/theme_style.dart';

class BottomsheetOptionButton extends StatelessWidget {

  final String text;
  final IconData icon; 
  final VoidCallback onPressed;

  const BottomsheetOptionButton({
    required this.text, 
    required this.icon, 
    required this.onPressed,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ThemeStyle.btnBottomsheetBgStyle,
      child: Row(
        children: [

          Icon(icon, color: ThemeStyle.btnBottomsheetIconColor),

          const SizedBox(width: 15),

          Text(
            text,
            style: ThemeStyle.btnBottomsheetTextStyle
          ),

        ],
      )
    );
  }

}