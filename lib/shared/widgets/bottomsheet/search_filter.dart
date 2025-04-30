import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/themes/theme_style.dart';
import 'package:revent/shared/widgets/bottomsheet/bottomsheet_widgets/bottomsheet.dart';
import 'package:revent/shared/widgets/bottomsheet/bottomsheet_widgets/bottomsheet_header.dart';

class BottomsheetSearchFilter {

  Widget _buildOptionButton({
    required String text,
    required bool isCurrentlySelected,
    required VoidCallback onPressed,
    IconData? icon
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ThemeStyle.btnBottomsheetBgStyle,
      child: Row(
        children: [

          if(icon != null)
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
              color: isCurrentlySelected ? ThemeColor.contentPrimary : ThemeColor.contentThird, 
              size: 20
            ),
          ),

        ],
      )
    );
  }

  Future buildSortOptionsBottomsheet({
    required BuildContext context,
    required String currentFilter,
    required VoidCallback bestOnPressed,
    required VoidCallback latestOnPressed,
    required VoidCallback oldestOnPressed,
    required VoidCallback controversialOnPressed,
  }) {
    return Bottomsheet().buildBottomSheet(
      context: context, 
      children: [

        const BottomsheetHeader(title: 'Sort Posts'),
        
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

        _buildOptionButton(
          text: 'Controversial',
          isCurrentlySelected: currentFilter == 'Controversial',
          icon: CupertinoIcons.flame,
          onPressed: controversialOnPressed
        ),

        const SizedBox(height: 25),

      ]
    );
  }
  
  Future buildTimeFilterBottomsheet({
    required BuildContext context,
    required String currentFilter,
    required VoidCallback allTimeOnPressed,
    required VoidCallback pastYearOnPressed,
    required VoidCallback pastMonthOnPressed,
    required VoidCallback pastWeekOnPressed,
    required VoidCallback todayOnPressed,
  }) {
    return Bottomsheet().buildBottomSheet(
      context: context, 
      children: [

        const BottomsheetHeader(title: 'Sort by Date'),

        _buildOptionButton(
          text: 'All Time',
          isCurrentlySelected: currentFilter == 'All Time',
          onPressed: allTimeOnPressed
        ),

        _buildOptionButton(
          text: 'Past Year',
          isCurrentlySelected: currentFilter == 'Past Year',
          onPressed: pastYearOnPressed
        ),

        _buildOptionButton(
          text: 'Past Month',
          isCurrentlySelected: currentFilter == 'Past Month',
          onPressed: pastMonthOnPressed
        ),

        _buildOptionButton(
          text: 'Past Week',
          isCurrentlySelected: currentFilter == 'Past Week',
          onPressed: pastWeekOnPressed
        ),

        _buildOptionButton(
          text: 'Today',
          isCurrentlySelected: currentFilter == 'Today',
          onPressed: todayOnPressed
        ),

        const SizedBox(height: 25),

      ]
    );
  }

}