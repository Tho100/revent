import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:revent/shared/themes/theme_style.dart';
import 'package:revent/shared/widgets/bottomsheet/bottomsheet_widgets/bottomsheet.dart';
import 'package:revent/shared/widgets/bottomsheet/bottomsheet_widgets/bottomsheet_bar.dart';
import 'package:revent/shared/widgets/bottomsheet/bottomsheet_widgets/bottomsheet_title.dart';

class BottomsheetUserActions {

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

          Icon(icon, color: ThemeStyle.btnBottomsheetIconColor),

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
    required VoidCallback reportOnPressed,
    required VoidCallback blockOnPressed,
    required VoidCallback aboutProfileOnPressed
  }) {
    return Bottomsheet().buildBottomSheet(
      context: context, 
      children: [

        const SizedBox(height: 12),

        const BottomsheetBar(),

        const BottomsheetTitle(title: 'User Action'),

        _buildOptionButton(
          text: 'About this profile',
          icon: CupertinoIcons.info_circle,
          onPressed: aboutProfileOnPressed
        ),

        _buildOptionButton(
          text: 'Report',
          icon: CupertinoIcons.flag,
          onPressed: reportOnPressed
        ),

        _buildOptionButton(
          text: 'Block',
          icon: CupertinoIcons.clear_circled,
          onPressed: blockOnPressed
        ),

        const SizedBox(height: 25),

      ]
    );
  }

}