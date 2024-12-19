import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/widgets/ui_dialog/profile_picture_dialog.dart';
import 'package:revent/shared/widgets/inkwell_effect.dart';
import 'package:revent/shared/widgets/profile_picture.dart';

class ProfileInfoWidgets {

  final String username;
  final Uint8List pfpData;

  ProfileInfoWidgets({
    required this.username,
    required this.pfpData,
  });

  Widget buildUsername() {
    return Text(
      username,
      style: GoogleFonts.inter(
        color: ThemeColor.white,
        fontWeight: FontWeight.w800,
        fontSize: 20.5
      ),
    );
  }

  Widget buildProfilePicture() {
    return InkWellEffect(
      onPressed: () => ProfilePictureDialog().showPfpDialog(pfpData),
      child: ProfilePictureWidget(
        customHeight: 70,
        customWidth: 70,
        customEmptyPfpSize: 30,
        pfpData: pfpData,
      ),
    );
  }

  Widget buildPopularityHeader(String header, int value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [

        Text(
          value.toString(),
          style: GoogleFonts.inter(
            color: ThemeColor.white,
            fontWeight: FontWeight.w800,
            fontSize: 20
          ),
          textAlign: TextAlign.start,
        ),

        const SizedBox(width: 6),

        Padding(
          padding: const EdgeInsets.only(bottom: 2.0),
          child: Text(
            header,
            style: GoogleFonts.inter(
              color: ThemeColor.secondaryWhite,
              fontWeight: FontWeight.w700,
              fontSize: 13
            ),
            textAlign: TextAlign.start,
          ),
        ),

      ],
    );
  }

  Widget buildPopularityHeaderNotifier(String header, ValueNotifier notifier) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
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
              textAlign: TextAlign.start,
            );
          },
        ),

        const SizedBox(width: 6),

        Padding(
          padding: const EdgeInsets.only(bottom: 2.0),
          child: Text(
            header,
            style: GoogleFonts.inter(
              color: ThemeColor.secondaryWhite,
              fontWeight: FontWeight.w700,
              fontSize: 13
            ),
            textAlign: TextAlign.start,
          ),
        ),

      ],
    );
  }

}