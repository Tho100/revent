import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/main.dart';
import 'package:revent/shared/themes/theme_style.dart';
import 'package:revent/shared/widgets/bottomsheet/bottomsheet_widgets/bottomsheet.dart';
import 'package:revent/shared/widgets/bottomsheet/bottomsheet_widgets/bottomsheet_bar.dart';
import 'package:revent/shared/widgets/bottomsheet/bottomsheet_widgets/bottomsheet_title.dart';

class BottomsheetReplyActions {

  final userData = getIt.userProvider.user;

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
    required String repliedBy,
    required VoidCallback copyOnPressed,
    required VoidCallback reportOnPressed,
    required VoidCallback blockOnPressed,
    required VoidCallback deleteOnPressed,
  }) {
    return Bottomsheet().buildBottomSheet(
      context: context, 
      children: [

        const SizedBox(height: 12),

        const BottomsheetBar(),

        const BottomsheetTitle(title: 'Reply Action'),

        _buildOptionButton(
          text: 'Copy text',
          icon: CupertinoIcons.doc_on_doc,
          onPressed: copyOnPressed
        ),

        if(userData.username != repliedBy)
        _buildOptionButton(
          text: 'Report reply',
          icon: CupertinoIcons.flag,
          onPressed: reportOnPressed
        ),

        if(userData.username == repliedBy)
        _buildOptionButton(
          text: 'Delete comment',
          icon: CupertinoIcons.trash,
          onPressed: deleteOnPressed
        ),

        if(userData.username != repliedBy)
        _buildOptionButton(
          text: 'Block @$repliedBy',
          icon: CupertinoIcons.clear_circled,
          onPressed: blockOnPressed
        ),

        const SizedBox(height: 25),

      ]
    );
  }

}