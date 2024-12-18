import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/themes/theme_style.dart';
import 'package:revent/shared/widgets/bottomsheet.dart';
import 'package:revent/shared/widgets/bottomsheet_bar.dart';
import 'package:revent/shared/widgets/bottomsheet_title.dart';

class BottomsheetVentFilter {

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
    required String tabName,
    required VoidCallback trendingOnPressed,
    required VoidCallback latestOnPressed,
  }) {
    return Bottomsheet().buildBottomSheet(
      context: context, 
      children: [

        const SizedBox(height: 12),

        const BottomsheetBar(),

        BottomsheetTitle(title: 'Sort $tabName'),

        _buildOptionButton(
          text: 'Trending',
          isCurrentlySelected: currentFilter == 'Trending',
          icon: CupertinoIcons.flame,
          onPressed: trendingOnPressed
        ),

        _buildOptionButton(
          text: 'Latest',
          isCurrentlySelected: currentFilter == 'Latest',
          icon: CupertinoIcons.bolt,
          onPressed: latestOnPressed
        ),

        const SizedBox(height: 25),

      ]
    );
  }
  
}