import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/main.dart';
import 'package:revent/shared/widgets/profile_picture.dart';

class NavigationPagesWidgets {

  static Widget settingsActionButton() {
    return IconButton(
      icon: const Icon(CupertinoIcons.bars, size: 28),
      onPressed: () => NavigatePage.settingsPage()
    );
  }

  static Widget profilePictureLeading() {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0),
      child: GestureDetector(
        onTap: () => NavigatePage.myProfilePage(),
        child: Center(
          child: ProfilePictureWidget(
            pfpData: getIt.profileProvider.profilePicture,
            customWidth: 34,
            customHeight: 34,
          ),
        ),
      ),
    );
  }

}