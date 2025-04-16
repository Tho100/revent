import 'package:flutter/cupertino.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/themes/theme_style.dart';
import 'package:revent/shared/widgets/bottomsheet/bottomsheet_widgets/bottomsheet.dart';
import 'package:revent/shared/widgets/bottomsheet/bottomsheet_widgets/bottomsheet_bar.dart';
import 'package:revent/shared/widgets/bottomsheet/bottomsheet_widgets/bottomsheet_title.dart';

class BottomsheetCommentsSettings {

  Widget _buildSwitch(ValueNotifier notifier, VoidCallback onToggled, String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 18.0, right: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [

              const Icon(CupertinoIcons.chat_bubble, color: ThemeStyle.btnBottomsheetIconColor),

              const SizedBox(width: 10),

              Text(
                text,
                style: ThemeStyle.btnBottomsheetTextStyle
              ),

              const Spacer(),

              ValueListenableBuilder(
                valueListenable: notifier,
                builder: (_, isToggled, __) {
                  return CupertinoSwitch(
                    value: isToggled,
                    onChanged: (_) {
                      notifier.value = !isToggled;
                      onToggled();
                    },
                    activeColor: ThemeColor.white,
                    trackColor: ThemeColor.darkWhite,
                    thumbColor: ThemeColor.black,
                  );
                }
              ),

            ],
          ),

        ],
      ),
    );
  }

  Future buildBottomsheet({
    required BuildContext context,
    required ValueNotifier notifier, 
    required VoidCallback onToggled, 
    required String text
  }) {
    return Bottomsheet().buildBottomSheet(
      context: context, 
      children: [

        const BottomsheetBar(),

        const BottomsheetTitle(title: 'Comment Settings'),

        _buildSwitch(
          notifier,
          onToggled,
          text
        ),

        const SizedBox(height: 25),

      ]
    );
  }

}