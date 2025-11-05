import 'package:flutter/cupertino.dart';
import 'package:revent/shared/widgets/bottomsheet/bottomsheet_widgets/bottomsheet.dart';
import 'package:revent/shared/widgets/bottomsheet/bottomsheet_widgets/filter_button.dart';
import 'package:revent/shared/widgets/bottomsheet/bottomsheet_widgets/header.dart';

class BottomsheetCommentFilter {

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

        const BottomsheetHeader(title: 'Sort Comments'),

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

        const SizedBox(height: 25),

      ]
    );
  }
  
}