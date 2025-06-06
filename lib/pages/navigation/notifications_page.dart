import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/helper/format_date.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/helper/providers_service.dart';
import 'package:revent/service/notification_service.dart';
import 'package:revent/shared/themes/theme_color.dart';
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

  final notificationNotifier = ValueNotifier<Map<String, List<dynamic>>>({});

  final formatTimestamp = FormatDate();

  void _initializeData() async {

    final prefs = await SharedPreferences.getInstance();

    final storedLikesJson = prefs.getString('post_like_cache') ?? '{}';
    final storedLikes = jsonDecode(storedLikesJson);

    if (storedLikes is Map) {
      notificationNotifier.value = Map<String, List<dynamic>>.from(storedLikes);
    }

  }

  Widget _buildHeart() {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: ThemeColor.likedColor
      ),
      child: const Icon(CupertinoIcons.heart_fill, color: Colors.white),
    );
  }

  Widget _buildMainInfo(String title, int likes, String likedAt) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        Text(
          likes == 1 ? 'Someone liked your post' : 'Your post received $likes likes',
          style: GoogleFonts.inter(
            color: ThemeColor.contentPrimary,
            fontWeight: FontWeight.w800,
            fontSize: 16
          ),
        ),

        const SizedBox(height: 8),

        Row(
          children: [

            Text(
              title,
              style: GoogleFonts.inter(
                color: ThemeColor.contentSecondary,
                fontWeight: FontWeight.w700,
                fontSize: 14
              ),
              maxLines: 1,
            ),

            const SizedBox(width: 6),

            Text(
              likedAt,
              style: GoogleFonts.inter(
                color: ThemeColor.contentThird,
                fontWeight: FontWeight.w700,
                fontSize: 13
              ),
            ),

          ],
        ),

      ],
    );
  }

  Widget _buildNotificationListView(List<String> titlesData, List<int> likesData, List<String> timestamp) {
    return ListView.builder(
      itemCount: titlesData.length,
      itemBuilder: (_, index) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: SizedBox(
            height: 50,
            child: Row(
              children: [
        
                _buildHeart(),

                const SizedBox(width: 12),
        
                _buildMainInfo(titlesData[index], likesData[index], timestamp[index]),

                const Spacer(),

                Padding(
                  padding: const EdgeInsets.only(right: 4.0),
                  child: Icon(Icons.arrow_forward_ios, color: ThemeColor.contentThird, size: 18),
                )
        
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody() {
    return ValueListenableBuilder(
      valueListenable: notificationNotifier,
      builder: (_, data, __) {

        final sortedEntries = data.entries.toList()
        ..sort((a, b) {
          final aTime = formatTimestamp.convertRelativeTimestampToDateTime(b.value[1]);
          final bTime = formatTimestamp.convertRelativeTimestampToDateTime(a.value[1]);
          return aTime.compareTo(bTime);
        });

        final titles = sortedEntries.map((e) => e.key).toList();
        final likes = sortedEntries.map((e) => e.value[0] as int).toList();
        final likedAt = sortedEntries.map((e) => e.value[1].toString()).toList();

        return _buildNotificationListView(titles, likes, likedAt);

      },
    );
  }

  @override
  void initState() {
    super.initState();
    _initializeData();
    NotificationService().markNotificationAsRead();
  }

  @override
  void dispose() {
    notificationNotifier.dispose();
    super.dispose();
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
        body: _buildBody(),
        bottomNavigationBar: PageNavigationBar()
      ),
    );
  }

}