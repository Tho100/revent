import 'package:flutter/cupertino.dart';
import 'package:revent/shared/widgets/bottomsheet/bottomsheet_widgets/bottomsheet.dart';
import 'package:revent/shared/widgets/bottomsheet/bottomsheet_widgets/bottomsheet_header.dart';
import 'package:revent/shared/widgets/bottomsheet/bottomsheet_widgets/bottomsheet_option_button.dart';

class BottomsheetProfilePictureOptions {

  Future buildBottomsheet({
    required BuildContext context,
    required VoidCallback changeAvatarOnPressed,
    required VoidCallback removeAvatarOnPressed,
  }) {
    return Bottomsheet().buildBottomSheet(
      context: context, 
      children: [

        const BottomsheetHeader(title: 'Options'),

        BottomsheetOptionButton(
          text: 'Change Avatar',
          icon: CupertinoIcons.camera,
          onPressed: changeAvatarOnPressed
        ),

        BottomsheetOptionButton(
          text: 'Remove Avatar',
          icon: CupertinoIcons.trash,
          onPressed: removeAvatarOnPressed
        ),

        const SizedBox(height: 25),

      ]
    );
  }

}