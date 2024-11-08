import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/provider/user_data_provider.dart';
import 'package:revent/themes/theme_color.dart';
import 'package:revent/themes/theme_style.dart';
import 'package:revent/widgets/bottomsheet.dart';
import 'package:revent/widgets/bottomsheet_bar.dart';
import 'package:revent/widgets/bottomsheet_title.dart';

class BottomsheetCommentActions {

  final userData = GetIt.instance<UserDataProvider>();

  Widget _buildOptionButton({
    required String text, 
    required IconData icon, 
    bool? isRed = false,
    required VoidCallback onPressed
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ThemeStyle.btnBottomsheetBgStyle,
      child: Row(
        children: [

          Icon(icon, color: isRed! ? ThemeColor.darkRed : ThemeColor.secondaryWhite),

          const SizedBox(width: 15),

          Text(
            text,
            style: isRed
              ? GoogleFonts.inter(
              color: ThemeColor.darkRed,
              fontWeight: FontWeight.w800,
              fontSize: 17,
              ) 
            : ThemeStyle.btnBottomsheetTextStyle,
          )

        ],
      )
    );
  }

  Future buildBottomsheet({
    required BuildContext context,
    required String commenter,
    required VoidCallback copyOnPressed,
    required VoidCallback reportOnPressed,
    required VoidCallback deleteOnPressed,
  }) {
    return Bottomsheet().buildBottomSheet(
      context: context, 
      children: [

        const SizedBox(height: 12),

        const BottomsheetBar(),

        const BottomsheetTitle(title: 'Comment Action'),

        _buildOptionButton(
          text: 'Copy',
          icon: CupertinoIcons.doc_on_doc,
          onPressed: copyOnPressed
        ),

        _buildOptionButton(
          text: 'Report',
          icon: CupertinoIcons.flag,
          isRed: true,
          onPressed: reportOnPressed
        ),

        if(userData.user.username == commenter)
        _buildOptionButton(
          text: 'Delete',
          icon: CupertinoIcons.trash,
          isRed: true,
          onPressed: deleteOnPressed
        ),

        const SizedBox(height: 25),

      ]
    );
  }

}