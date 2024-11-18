import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:revent/themes/theme_color.dart';
import 'package:revent/themes/theme_style.dart';
import 'package:revent/widgets/bottomsheet.dart';
import 'package:revent/widgets/bottomsheet_bar.dart';
import 'package:revent/widgets/bottomsheet_title.dart';

class BottomsheetCommentFilter {

  Widget _buildOptionButton({
    required String text, 
    required IconData icon, 
    required VoidCallback onPressed
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ThemeStyle.btnBottomsheetBgStyle,
      child: Row(
        children: [

          Icon(icon, color: ThemeColor.secondaryWhite),

          const SizedBox(width: 15),

          Text(
            text,
            style: ThemeStyle.btnBottomsheetTextStyle
          )

        ],
      )
    );
  }

  Future buildBottomsheet({
    required BuildContext context,
    required VoidCallback bestOnPressed,
    required VoidCallback latestOnPressed,
    required VoidCallback oldestOnPressed,
  }) {
    return Bottomsheet().buildBottomSheet(
      context: context, 
      children: [

        const SizedBox(height: 12),

        const BottomsheetBar(),

        const BottomsheetTitle(title: 'Filter Comments'),

        _buildOptionButton(
          text: 'Best',
          icon: CupertinoIcons.star,
          onPressed: bestOnPressed
        ),

        _buildOptionButton(
          text: 'Latest',
          icon: CupertinoIcons.up_arrow,
          onPressed: latestOnPressed
        ),

        _buildOptionButton(
          text: 'Oldest',
          icon: CupertinoIcons.down_arrow,
          onPressed: oldestOnPressed
        ),

        const SizedBox(height: 25),

      ]
    );
  }
  
}