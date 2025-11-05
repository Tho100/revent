import 'package:flutter/cupertino.dart';
import 'package:revent/shared/widgets/bottomsheet/bottomsheet_widgets/bottomsheet.dart';
import 'package:revent/shared/widgets/bottomsheet/bottomsheet_widgets/header.dart';
import 'package:revent/shared/widgets/bottomsheet/bottomsheet_widgets/option_buttons.dart';

class BottomsheetCountryOptions {

  Future buildBottomsheet({
    required BuildContext context,
    required VoidCallback changeCountryOnPressed,
    required VoidCallback removeCountryOnPressed,
  }) {
    return Bottomsheet().buildBottomSheet(
      context: context, 
      children: [

        const BottomsheetHeader(title: 'Options'),

        BottomsheetOptionButton(
          text: 'Change Country',
          icon: CupertinoIcons.location_solid,
          onPressed: changeCountryOnPressed
        ),

        BottomsheetOptionButton(
          text: 'Remove Country',
          icon: CupertinoIcons.trash,
          onPressed: removeCountryOnPressed
        ),

        const SizedBox(height: 25),

      ]
    );
  }

}