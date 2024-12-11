import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/provider/profile/profile_data_provider.dart';
import 'package:revent/widgets/profile_picture.dart';

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
            pfpData: GetIt.instance<ProfileDataProvider>().profilePicture,
            customWidth: 34,
            customHeight: 34,
          ),
        ),
      ),
    );
  }

}