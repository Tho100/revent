import 'package:flutter/cupertino.dart';
import 'package:revent/shared/widgets/bottomsheet/bottomsheet_widgets/bottomsheet.dart';
import 'package:revent/shared/widgets/bottomsheet/bottomsheet_widgets/bottomsheet_bar.dart';
import 'package:revent/shared/widgets/bottomsheet/bottomsheet_widgets/bottomsheet_option_button.dart';
import 'package:revent/shared/widgets/bottomsheet/bottomsheet_widgets/bottomsheet_title.dart';

class BottomsheetUserActions {

  Future buildBottomsheet({
    required BuildContext context,
    required VoidCallback reportOnPressed,
    required VoidCallback blockOnPressed,
    required VoidCallback aboutProfileOnPressed
  }) {
    return Bottomsheet().buildBottomSheet(
      context: context, 
      children: [

        const BottomsheetBar(),

        const BottomsheetTitle(title: 'User Options'),

        BottomsheetOptionButton(
          text: 'About this profile',
          icon: CupertinoIcons.info_circle,
          onPressed: aboutProfileOnPressed
        ),

        BottomsheetOptionButton(
          text: 'Report',
          icon: CupertinoIcons.flag,
          onPressed: reportOnPressed
        ),

        BottomsheetOptionButton(
          text: 'Block',
          icon: CupertinoIcons.clear_circled,
          onPressed: blockOnPressed
        ),

        const SizedBox(height: 25),

      ]
    );
  }

}