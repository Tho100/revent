import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/themes/theme_style.dart';
import 'package:revent/shared/widgets/bottomsheet/bottomsheet_widgets/bottomsheet.dart';
import 'package:revent/shared/widgets/bottomsheet/bottomsheet_widgets/bottomsheet_bar.dart';
import 'package:revent/shared/widgets/bottomsheet/bottomsheet_widgets/bottomsheet_title.dart';

class BottomsheetCommentFilter {

  Widget _buildOptionButton({
    required String text,
    required bool isCurrentlySelected,
    required IconData icon, 
    required VoidCallback onPressed
  }) {
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

          const Spacer(),

          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Icon(
              isCurrentlySelected ? CupertinoIcons.check_mark_circled : CupertinoIcons.circle, 
              color: isCurrentlySelected ? ThemeColor.white : ThemeColor.thirdWhite, 
              size: 20
            ),
          ),

        ],
      )
    );
  }

  Future buildBottomsheet({
    required BuildContext context,
    required String currentFilter,
    required VoidCallback bestOnPressed,
    required VoidCallback latestOnPressed,
    required VoidCallback oldestOnPressed,
  }) {
    return Bottomsheet().buildBottomSheet(
      context: context, 
      children: [

        const SizedBox(height: 12),

        const BottomsheetBar(),

        const BottomsheetTitle(title: 'Sort Comments'),

        _buildOptionButton(
          text: 'Best',
          isCurrentlySelected: currentFilter == 'Best',
          icon: CupertinoIcons.star,
          onPressed: bestOnPressed
        ),

        _buildOptionButton(
          text: 'Latest',
          isCurrentlySelected: currentFilter == 'Latest',
          icon: CupertinoIcons.bolt,
          onPressed: latestOnPressed
        ),

        _buildOptionButton(
          text: 'Oldest',
          isCurrentlySelected: currentFilter == 'Oldest',
          icon: CupertinoIcons.clock,
          onPressed: oldestOnPressed
        ),

        const SizedBox(height: 25),

      ]
    );
  }
  
}