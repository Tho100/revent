import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/themes/theme_style.dart';
import 'package:revent/shared/widgets/bottomsheet/bottomsheet_widgets/bottomsheet.dart';
import 'package:revent/shared/widgets/bottomsheet/bottomsheet_widgets/bottomsheet_bar.dart';
import 'package:revent/shared/widgets/bottomsheet/bottomsheet_widgets/bottomsheet_title.dart';

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
              color: isCurrentlySelected ? ThemeColor.white : ThemeColor.thirdWhite, 
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

        const SizedBox(height: 12),

        const BottomsheetBar(),

        const BottomsheetTitle(title: 'Sort Posts'),

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
          isCurrentlySelected: currentFilter == 'Oldest',
          icon: CupertinoIcons.flame,
          onPressed: oldestOnPressed
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

        const SizedBox(height: 12),

        const BottomsheetBar(),

        const BottomsheetTitle(title: 'Sort Posts by Time'),

        _buildOptionButton(
          text: 'All time',
          isCurrentlySelected: currentFilter == 'All time',
          onPressed: allTimeOnPressed
        ),

        _buildOptionButton(
          text: 'Past year',
          isCurrentlySelected: currentFilter == 'Past year',
          onPressed: pastYearOnPressed
        ),

        _buildOptionButton(
          text: 'Past month',
          isCurrentlySelected: currentFilter == 'Past month',
          onPressed: pastMonthOnPressed
        ),

        _buildOptionButton(
          text: 'Past week',
          isCurrentlySelected: currentFilter == 'Past week',
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