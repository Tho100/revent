import 'package:flutter/cupertino.dart';
import 'package:revent/shared/widgets/bottomsheet/bottomsheet_widgets/bottomsheet.dart';
import 'package:revent/shared/widgets/bottomsheet/bottomsheet_widgets/bottomsheet_filter_button.dart';
import 'package:revent/shared/widgets/bottomsheet/bottomsheet_widgets/bottomsheet_header.dart';

class BottomsheetSearchFilter {

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
        
        BottomsheetFilterButton(
          text: 'Best',
          isCurrentlySelected: currentFilter == 'Best',
          icon: CupertinoIcons.star,
          onPressed: bestOnPressed
        ),

        BottomsheetFilterButton(
          text: 'Latest',
          isCurrentlySelected: currentFilter == 'Latest',
          icon: CupertinoIcons.bolt,
          onPressed: latestOnPressed
        ),

        BottomsheetFilterButton(
          text: 'Oldest',
          isCurrentlySelected: currentFilter == 'Oldest',
          icon: CupertinoIcons.clock,
          onPressed: oldestOnPressed
        ),

        BottomsheetFilterButton(
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

        BottomsheetFilterButton(
          text: 'All Time',
          isCurrentlySelected: currentFilter == 'All Time',
          onPressed: allTimeOnPressed
        ),

        BottomsheetFilterButton(
          text: 'Past Year',
          isCurrentlySelected: currentFilter == 'Past Year',
          onPressed: pastYearOnPressed
        ),

        BottomsheetFilterButton(
          text: 'Past Month',
          isCurrentlySelected: currentFilter == 'Past Month',
          onPressed: pastMonthOnPressed
        ),

        BottomsheetFilterButton(
          text: 'Past Week',
          isCurrentlySelected: currentFilter == 'Past Week',
          onPressed: pastWeekOnPressed
        ),

        BottomsheetFilterButton(
          text: 'Today',
          isCurrentlySelected: currentFilter == 'Today',
          onPressed: todayOnPressed
        ),

        const SizedBox(height: 25),

      ]
    );
  }

}