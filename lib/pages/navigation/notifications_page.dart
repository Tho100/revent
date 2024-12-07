import 'package:flutter/material.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/widgets/navigation/page_navigation_bar.dart';
import 'package:revent/widgets/app_bar.dart';
import 'package:revent/widgets/navigation_pages_widgets.dart';

class NotificationsPage extends StatelessWidget {

  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        NavigatePage.homePage();
        return true;
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Notifications',
          customBackOnPressed: () => NavigatePage.homePage(),
          context: context,
          customLeading: NavigationPagesWidgets.profilePictureLeading(),
          actions: [NavigationPagesWidgets.settingsActionButton()]
        ).buildAppBar(),
        bottomNavigationBar: PageNavigationBar()
      ),
    );
  }

}