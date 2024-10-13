import 'package:flutter/material.dart';
import 'package:revent/themes/theme_color.dart';
import 'package:revent/themes/theme_style.dart';
import 'package:revent/widgets/bottomsheet.dart';
import 'package:revent/widgets/bottomsheet_bar.dart';
import 'package:revent/widgets/bottomsheet_title.dart';

class BottomsheetAddItem {

  Widget _buildAddItemButton({
    required String text,
    required IconData icon,
    required VoidCallback onPressed
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ThemeStyle.btnBottomDialogBackgroundStyle,
      child: Row(
        children: [

          Icon(icon, color: ThemeColor.secondaryWhite),
          
          const SizedBox(width: 15.0),

          Text(
            text,
            style: ThemeStyle.btnBottomDialogTextStyle
          ),

        ],
      ),
    );
  }

  Future buildBottomsheet({
    required BuildContext context,
    required VoidCallback addVentOnPressed,
    required VoidCallback addForumOnPressed
  }) {
    return Bottomsheet().buildBottomSheet(
      context: context, 
      children: [

        const SizedBox(height: 12),

        const BottomsheetBar(),

        const BottomsheetTitle(title: 'Create'),

        const Divider(color: ThemeColor.lightGrey),

        _buildAddItemButton(
          text: 'Create a vent',
          icon: Icons.add,
          onPressed: addVentOnPressed
        ),

        _buildAddItemButton(
          text: 'Create a new vent forum',
          icon: Icons.add,
          onPressed: addForumOnPressed
        ),

        const SizedBox(height: 20),

      ]
    );
  }

}