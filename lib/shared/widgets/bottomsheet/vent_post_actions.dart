import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/main.dart';
import 'package:revent/shared/themes/theme_style.dart';
import 'package:revent/shared/widgets/bottomsheet/bottomsheet_widgets/bottomsheet.dart';
import 'package:revent/shared/widgets/bottomsheet/bottomsheet_widgets/bottomsheet_bar.dart';
import 'package:revent/shared/widgets/bottomsheet/bottomsheet_widgets/bottomsheet_title.dart';

class BottomsheetVentPostActions {

  final userData = getIt.userProvider;

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
            style: ThemeStyle.btnBottomsheetTextStyle,
          )

        ],
      )
    );
  }

  Future buildBottomsheet({
    required BuildContext context,
    required String title,
    required String creator,
    VoidCallback? editOnPressed,
    VoidCallback? reportOnPressed,
    VoidCallback? removeSavedPostOnPressed,
    VoidCallback? blockOnPressed,
    VoidCallback? copyOnPressed,
    VoidCallback? deleteOnPressed,
  }) {
    return Bottomsheet().buildBottomSheet(
      context: context, 
      children: [

        const SizedBox(height: 12),

        const BottomsheetBar(),

        const BottomsheetTitle(title: 'Post Action'),

        if(removeSavedPostOnPressed != null)
        _buildOptionButton(
          text: 'Unsave',
          icon: CupertinoIcons.bookmark_fill,
          onPressed: removeSavedPostOnPressed
        ),

        if(userData.user.username == creator && editOnPressed != null)
        _buildOptionButton(
          text: 'Edit post',
          icon: CupertinoIcons.square_pencil,
          onPressed: editOnPressed
        ),

        if(copyOnPressed != null)
        _buildOptionButton(
          text: 'Copy body',
          icon: CupertinoIcons.doc_on_doc,
          onPressed: copyOnPressed
        ),

        if(userData.user.username != creator && reportOnPressed != null)
        _buildOptionButton(
          text: 'Report post',
          icon: CupertinoIcons.flag,
          onPressed: reportOnPressed
        ),

        if(userData.user.username != creator && blockOnPressed != null)
        _buildOptionButton(
          text: 'Block @$creator',
          icon: CupertinoIcons.clear_circled,
          onPressed: blockOnPressed
        ),

        if(userData.user.username == creator && deleteOnPressed != null)
        _buildOptionButton(
          text: 'Delete post',
          icon: CupertinoIcons.trash,
          onPressed: deleteOnPressed
        ),

        const SizedBox(height: 25),

      ]
    );
  }

}