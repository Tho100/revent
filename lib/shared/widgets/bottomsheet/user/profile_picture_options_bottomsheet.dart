import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:revent/shared/themes/theme_style.dart';
import 'package:revent/shared/widgets/bottomsheet/bottomsheet_widgets/bottomsheet.dart';
import 'package:revent/shared/widgets/bottomsheet/bottomsheet_widgets/bottomsheet_bar.dart';
import 'package:revent/shared/widgets/bottomsheet/bottomsheet_widgets/bottomsheet_title.dart';

class BottomsheetProfilePictureOptions {

  Widget _buildOptionButton({ // TODO: Try to create a separated widget class for this
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
            style: ThemeStyle.btnBottomsheetTextStyle,
          )

        ],
      )
    );
  }

  Future buildBottomsheet({
    required BuildContext context,
    required VoidCallback changeAvatarOnPressed,
    required VoidCallback removeAvatarOnPressed,
  }) {
    return Bottomsheet().buildBottomSheet(
      context: context, 
      children: [

        const SizedBox(height: 12),

        const BottomsheetBar(),

        const BottomsheetTitle(title: 'Options'),

        _buildOptionButton(
          text: 'Upload avatar',
          icon: CupertinoIcons.photo,
          onPressed: changeAvatarOnPressed
        ),

        _buildOptionButton(
          text: 'Remove avatar',
          icon: CupertinoIcons.trash,
          onPressed: removeAvatarOnPressed
        ),

        const SizedBox(height: 25),

      ]
    );
  }

}