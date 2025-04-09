import 'package:flutter/cupertino.dart';
import 'package:revent/shared/widgets/bottomsheet/bottomsheet_widgets/bottomsheet.dart';
import 'package:revent/shared/widgets/bottomsheet/bottomsheet_widgets/bottomsheet_bar.dart';
import 'package:revent/shared/widgets/bottomsheet/bottomsheet_widgets/bottomsheet_option_button.dart';
import 'package:revent/shared/widgets/bottomsheet/bottomsheet_widgets/bottomsheet_title.dart';

class BottomsheetProfilePictureOptions {

  Future buildBottomsheet({
    required BuildContext context,
    required VoidCallback changeAvatarOnPressed,
    required VoidCallback removeAvatarOnPressed,
  }) {
    return Bottomsheet().buildBottomSheet(
      context: context, 
      children: [

        const BottomsheetBar(),

        const BottomsheetTitle(title: 'Options'),

        BottomsheetOptionButton(
          text: 'Change avatar',
          icon: CupertinoIcons.camera,
          onPressed: changeAvatarOnPressed
        ),

        BottomsheetOptionButton(
          text: 'Remove avatar',
          icon: CupertinoIcons.trash,
          onPressed: removeAvatarOnPressed
        ),

        const SizedBox(height: 25),

      ]
    );
  }

}