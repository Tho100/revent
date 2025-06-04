import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/helper/providers_service.dart';
import 'package:revent/service/query/notification/post_notification_getter.dart';
import 'package:revent/shared/widgets/navigation/page_navigation_bar.dart';
import 'package:revent/shared/widgets/app_bar.dart';
import 'package:revent/shared/widgets/navigation_pages_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationsPage extends StatefulWidget {

  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> with NavigationProviderService {

  void _toggleReadMark() async {
    
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('hasUnreadNotifications', false);

    final currentLikes = await VentPostNotificationGetter().getPostLikes();
    final postIds = currentLikes['post_id']!;
    final likeCounts = currentLikes['like_count']!;

    final newCache = <String, int>{};
    
    for (int i = 0; i < postIds.length; i++) {
      newCache[postIds[i].toString()] = likeCounts[i];
    }

    await prefs.setString('post_like_cache', jsonEncode(newCache)).then(
      (_) => navigationProvider.setBadgeVisible(false)
    );

  }

  @override
  void initState() {
    super.initState();
    _toggleReadMark();
  }

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
          actions: [NavigationPagesWidgets.profilePictureLeading()]
        ).buildNavigationAppBar(),
        bottomNavigationBar: PageNavigationBar()
      ),
    );
  }

}