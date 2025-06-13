
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/helper/cache_helper.dart';
import 'package:revent/helper/format_date.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/helper/providers_service.dart';
import 'package:revent/pages/vent/vent_post_page.dart';
import 'package:revent/service/notification_service.dart';
import 'package:revent/service/query/general/post_id_getter.dart';
import 'package:revent/service/query/vent/vent_data_getter.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/widgets/inkwell_effect.dart';
import 'package:revent/shared/widgets/app_bar.dart';
import 'package:revent/shared/widgets/navigation/navigation_bar_dock.dart';
import 'package:revent/shared/widgets/navigation_pages_widgets.dart';

class NotificationsPage extends StatefulWidget {

  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();

}

class _NotificationsPageState extends State<NotificationsPage> with 
  NavigationProviderService, 
  UserProfileProviderService {

  final notificationNotifier = ValueNotifier<Map<String, List<dynamic>>>({});

  final notificationService = NotificationService();

  final likedPostType = 'liked_post';
  final newFollowerType = 'new_follower';

  void _initializeNotificationData() async {

    final caches = await CacheHelper().getNotificationCache();

    final storedLikes = caches['post_likes_cache'];
    final storedFollowers = caches['followers_cache'];

    final Map<String, List<dynamic>> combined = {}; 

    if (storedLikes is Map) {
      storedLikes.forEach((title, data) {
        combined[title] = [data[0], data[1], likedPostType];
      });
    }

    if (storedFollowers is Map) {
      storedFollowers.forEach((username, data) {
        combined[username] = [0, data[0], newFollowerType];
      });
    }

    notificationNotifier.value = combined;

  }

  Future<void> _navigateToLikedPost({required String title}) async {
    
    final postId = await PostIdGetter(title: title, creator: userProvider.user.username).getPostId();

    final ventDataGetter = VentDataGetter(postId: postId);

    final bodyText = await ventDataGetter.getBodyText();
    final metadata = await ventDataGetter.getMetadata();

    final tags = metadata['tags'];
    final totalLikes = metadata['total_likes'];
    final postTimestamp = metadata['post_timestamp'];
    final isNsfw = metadata['is_nsfw'];

    if (context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VentPostPage(
            title: title, 
            postId: postId,
            bodyText: bodyText, 
            tags: tags,
            postTimestamp: postTimestamp,
            isNsfw: isNsfw,
            totalLikes: totalLikes,
            creator: userProvider.user.username, 
            pfpData: profileProvider.profile.profilePicture,
          )
        ),
      );
    }

  }

  Future<void> _refreshNotifications() async {

    notificationNotifier.value.clear();

    await notificationService.initializeNotifications().then(
      (_) => _initializeNotificationData()
    );

    await notificationService.markNotificationAsRead();

  }

  Widget _buildPostLikedBadge() {
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

  Widget _buildNewFollowerBadge() {
    return Container(
      width: 45,
      height: 45,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blueAccent
      ),
      child: const Icon(CupertinoIcons.person_add, color: Colors.white),
    );
  }

  Widget _buildMainInfo(String notificationSubject, int likes, String timestamp, {String type = 'like'}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        Text(
          type == newFollowerType
            ? '$notificationSubject followed you'
            : likes == 1 ? 'Someone liked your post' : 'Your post received $likes likes',
          style: GoogleFonts.inter(
            color: ThemeColor.contentPrimary,
            fontWeight: FontWeight.w800,
            fontSize: 16,
          ),
        ),

        const SizedBox(height: 8),

        Row(
          mainAxisSize: MainAxisSize.min,
          children: [

            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.45,
              ),
              child: Text(
                type == newFollowerType ? '' : notificationSubject,
                style: GoogleFonts.inter(
                  color: ThemeColor.contentSecondary,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),

            if (type == likedPostType) const SizedBox(width: 6),

            Text(
              timestamp,
              style: GoogleFonts.inter(
                color: ThemeColor.contentThird,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),

          ],

        ),

      ],
    );
  }

  Widget _buildNotificationListView({
    required List<String> notificationSubjects,
    required List<int> likesData,
    required List<String> timestamp,
    required List<String> types
  }) {
    return RefreshIndicator(
      color: ThemeColor.backgroundPrimary,
      backgroundColor: ThemeColor.contentPrimary,
      onRefresh: () async => await _refreshNotifications(),
      child: Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics()
          ),
          itemCount: notificationSubjects.length,
          itemBuilder: (_, index) {

            final type = types[index];

            return InkWellEffect(
              onPressed: () async { 

                if (type == likedPostType) {
                  await _navigateToLikedPost(title: notificationSubjects[index]);
                  
                } else if (type == newFollowerType) {
                  NavigatePage.userProfilePage(username: notificationSubjects[index]);
                }

              },
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Row(
                    children: [

                      type == likedPostType 
                        ? _buildPostLikedBadge() 
                        : _buildNewFollowerBadge(),

                      const SizedBox(width: 12),

                      _buildMainInfo(
                        notificationSubjects[index],
                        likesData[index],
                        timestamp[index],
                        type: type,
                      ),

                      const Spacer(),

                      Padding(
                        padding: const EdgeInsets.only(right: 4.0),
                        child: Icon(Icons.arrow_forward_ios, color: ThemeColor.contentThird, size: 18),
                      ),

                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody() {
    return ValueListenableBuilder(
      valueListenable: notificationNotifier,
      builder: (_, data, __) {

        final formatTimestamp = FormatDate();

        final sortedEntries = data.entries.toList()
          ..sort((a, b) {
            final aTime = formatTimestamp.convertRelativeTimestampToDateTime(b.value[1]);
            final bTime = formatTimestamp.convertRelativeTimestampToDateTime(a.value[1]);
            return aTime.compareTo(bTime);
          }
        );

        final notificationSubjects = sortedEntries.map((e) => e.key).toList();
        final notificationTimestamp = sortedEntries.map((e) => e.value[1].toString()).toList();
        final likes = sortedEntries.map((e) => e.value[0] as int).toList();

        final types = sortedEntries.map(
          (e) => e.value.length > 2 ? e.value[2].toString() : likedPostType
        ).toList();

        return _buildNotificationListView(
          notificationSubjects: notificationSubjects, 
          timestamp: notificationTimestamp, 
          likesData: likes, 
          types: types
        );

      },
    );
  }

  @override
  void initState() {
    super.initState();
    _initializeNotificationData();
    notificationService.markNotificationAsRead();
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
        bottomNavigationBar: NavigationBarDock()
      ),
    );
  }

}