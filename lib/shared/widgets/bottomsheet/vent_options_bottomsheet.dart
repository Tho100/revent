import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/themes/theme_style.dart';
import 'package:revent/shared/widgets/bottomsheet/bottomsheet_widgets/bottomsheet.dart';
import 'package:revent/shared/widgets/bottomsheet/bottomsheet_widgets/bottomsheet_bar.dart';
import 'package:revent/shared/widgets/bottomsheet/bottomsheet_widgets/bottomsheet_title.dart';

class BottomsheetVentOptions {

  Widget _buildOptionButton({
    required ValueNotifier notifier,
    required VoidCallback onToggled,
    required String text, 
    bool? isNSFW = false,
    IconData? icon
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 18.0, right: 18.0, bottom: 12.0),
      child: Row(
        children: [
    
          isNSFW!
            ? Text(
              '18+',
                style: GoogleFonts.inter(
                  color: ThemeColor.nsfwColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w700
                )
              )
            : Icon(icon, color: ThemeStyle.btnBottomsheetIconColor),
    
          SizedBox(width: isNSFW ? 10 : 15),
    
          Text(
            text,
            style: ThemeStyle.btnBottomsheetTextStyle,
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
    );
  }

  Future buildBottomsheet({
    required BuildContext context,
    required ValueNotifier commentNotifier,
    required ValueNotifier archiveNotifier,
    required ValueNotifier markNsfwNotifier,
    required VoidCallback commentOnToggled,
    required VoidCallback archiveOnToggled,
    required VoidCallback markNsfwOnToggled,
  }) {
    return Bottomsheet().buildBottomSheet(
      context: context, 
      children: [

        const SizedBox(height: 12),

        const BottomsheetBar(),

        const BottomsheetTitle(title: 'Options'),

        _buildOptionButton(          
          notifier: commentNotifier,
          onToggled: commentOnToggled,
          text: 'Allow commenting',
          icon: CupertinoIcons.chat_bubble,
        ),

        _buildOptionButton(
          notifier: archiveNotifier,
          onToggled: archiveOnToggled,
          text: 'Archive vent',
          icon: CupertinoIcons.archivebox
        ),

        const Divider(color: ThemeColor.lightGrey),

        const SizedBox(height: 10),

        _buildOptionButton(
          notifier: markNsfwNotifier,
          onToggled: markNsfwOnToggled,
          text: 'Mark as NSFW',
          isNSFW: true
        ),

        const SizedBox(height: 20)

      ]
    );
  }

}