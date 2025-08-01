import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/themes/theme_style.dart';

class BottomsheetFilterButton extends StatelessWidget {

  final String text;
  final IconData? icon; 
  final VoidCallback onPressed;
  final bool isCurrentlySelected;

  const BottomsheetFilterButton({
    required this.text, 
    required this.onPressed,
    required this.isCurrentlySelected,
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

          const Spacer(),

          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Icon(
              isCurrentlySelected ? CupertinoIcons.check_mark_circled : CupertinoIcons.circle, 
              color: isCurrentlySelected ? ThemeColor.contentPrimary : ThemeColor.contentThird, 
              size: 20
            ),
          ),

        ],
      )
    );
  }

}