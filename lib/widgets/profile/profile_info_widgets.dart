import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/themes/theme_color.dart';
import 'package:revent/themes/theme_style.dart';
import 'package:revent/ui_dialog/profile_picture_dialog.dart';
import 'package:revent/widgets/inkwell_effect.dart';
import 'package:revent/widgets/profile_picture.dart';

class ProfileInfoWidgets {

  final BuildContext context;

  final String username;
  final Uint8List pfpData;

  ProfileInfoWidgets({
    required this.context,
    required this.username,
    required this.pfpData,
  });

  Widget buildUsername() {
    return Text(
      username,
      style: ThemeStyle.profileUsernameStyle
    );
  }

  Widget buildProfilePicture() {
    return InkWellEffect(
      onPressed: () => ProfilePictureDialog().showPfpDialog(context, pfpData),
      child: ProfilePictureWidget(
        customHeight: 75,
        customWidth: 75,
        pfpData: pfpData,
      ),
    );
  }

  Widget buildPopularityHeader(String header, int value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        Text(
          value.toString(),
          style: GoogleFonts.inter(
            color: ThemeColor.white,
            fontWeight: FontWeight.w800,
            fontSize: 20
          ),
        ),

        const SizedBox(height: 4),

        Text(
          header,
          style: GoogleFonts.inter(
            color: ThemeColor.white,
            fontWeight: FontWeight.w700,
            fontSize: 14.5
          ),
        ),

      ],
    );
  }

  Widget buildPopularityHeaderNotifier(String header, ValueNotifier notifier) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        ValueListenableBuilder(
          valueListenable: notifier,
          builder: (_, value, __) {
            return Text(
              value.toString(),
              style: GoogleFonts.inter(
                color: ThemeColor.white,
                fontWeight: FontWeight.w800,
                fontSize: 20
              ),
            );
          },
        ),

        const SizedBox(height: 4),

        Text(
          header,
          style: GoogleFonts.inter(
            color: ThemeColor.white,
            fontWeight: FontWeight.w700,
            fontSize: 14.5
          ),
        ),

      ],
    );
  }

}